import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/app/app_event.dart';
import 'package:what_is_my_name/alerts/congratulations_screen.dart';
import 'package:what_is_my_name/alerts/error_screen.dart';
import 'package:what_is_my_name/alerts/match_screen.dart';
import 'package:what_is_my_name/repositories/auth_repository.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/constants.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/strings.dart';

import 'app/app_bloc.dart';
import 'app/app_state.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initialRoute;
  final GlobalKey<NavigatorState> _key = GlobalKey();

  @override
  void didChangeDependencies() async {
    await _getInitialRoute();
    setState(() => _initialRoute);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (_initialRoute == null)
      return Container(color: AppColors.white);
    else
      return BlocProvider<AppBloc>(
        create: (context) => AppBloc(AppInitialState()),
        child: BlocConsumer<AppBloc, AppState>(
            listener: (context, state) {
              if (state is PartnerPairedState) {
                _key.currentState.popUntil((route) => route.isFirst);
                _key.currentState.pushReplacementNamed(Routes.congratulationsScreen,
                    arguments: CongratulationsScreenArgs(
                        Strings.bothPartnersConnectedText, Routes.nameScreen));
              } else if (state is InternetConnectionUnavailableState)
                _key.currentState.pushNamed(Routes.errorScreen, arguments: ErrorScreenArgs(state.message));
              else if (state is MatchState)
                _key.currentState.pushNamed(Routes.matchScreen,
                    arguments: MatchScreenArgs(state.name));
            },
            buildWhen: (previousState, state) => state is AppInitialState,
            builder: (context, state) {
              BlocProvider.of<AppBloc>(context)
                  .add(ListenForPartnerPairingEvent());
              BlocProvider.of<AppBloc>(context)
                  .add(ListenForInternetConnectionChangesEvent());
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: _key,
                title: Strings.whatIsMyNameText,
                theme: ThemeData(
                  fontFamily: Constants.rubikFont,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                onGenerateRoute: (settings) => Routes.chooseRoute(settings),
                initialRoute: _initialRoute,
              );
            }),
      );
  }

  Future<void> _getInitialRoute() async {
    final authRepository = AuthRepository();
    final sharedPrefsRepository = SharedPrefsRepository();
    if ( authRepository.isSignedIn()) {
      final sexOfBaby = await sharedPrefsRepository.getChosenGender();
      final pairingCode = await sharedPrefsRepository.getPairingCode();
      if (sexOfBaby == null || sexOfBaby == "")
        _initialRoute = Routes.chooseGenderScreen;
      else if(pairingCode == null)
        _initialRoute = Routes.whoScreen;
      else
        _initialRoute = Routes.nameScreen;
    } else
      _initialRoute = Routes.welcomeScreen;
  }
}
