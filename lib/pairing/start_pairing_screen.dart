import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:what_is_my_name/alerts/error_screen.dart';
import 'package:what_is_my_name/alerts/loading_screen.dart';
import 'package:what_is_my_name/app/app_bloc.dart';
import 'package:what_is_my_name/app/app_event.dart';
import 'package:what_is_my_name/name/name_screen.dart';
import 'package:what_is_my_name/pairing/pairing_bloc.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_confirm_button.dart';
import 'package:what_is_my_name/widgets/app_text_field.dart';
import 'package:what_is_my_name/widgets/share_button.dart';

import 'pairing_event.dart';
import 'pairing_state.dart';

class StartPairingScreen extends StatefulWidget {
  @override
  _StartPairingScreenState createState() => _StartPairingScreenState();
}

class _StartPairingScreenState extends State<StartPairingScreen> {
  final TextEditingController _textFieldController = TextEditingController();
  final SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();
  PairingBloc _pairingBloc;
  String _route;

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pairingBloc = BlocProvider.of<PairingBloc>(context);
    _pairingBloc.add(GenerateCodeEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    final gender = await _sharedPrefsRepository.getChosenGender();
    if (gender == null || gender == "")
      _route = Routes.chooseGenderScreen;
    else
      _route = Routes.nameScreen;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.primaryGreen,
      ),
      body: BlocConsumer<PairingBloc, PairingState>(listener: (context, state) {
        if (state is StartConnectionFailureState) {
          Navigator.pushNamed(context, Routes.errorScreen, arguments: ErrorScreenArgs(state.message));
        } else if (state is StartPairingSuccessState) {
          BlocProvider.of<AppBloc>(context).add(ListenForPartnerPairingEvent());
        } else if (state is SendCodeState)
          Share.share(_textFieldController.text, subject: Strings.shareCodeDescription);
        else if (state is CodeGeneratedState) {
          _textFieldController.text = state.code;
          BlocProvider.of<PairingBloc>(context)
              .add(StartPairingEvent(_textFieldController.text));
        }
      }, builder: (context, state) {
        if (state is PairingInProgressState) {
          return LoadingScreen(LoadingScreenArgs(state.message));
        } else if (state is CodeGenerationInProgress)
          return LoadingScreen(LoadingScreenArgs(state.message));
        else
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 1),
              _buildTitle(),
              SizedBox(height: 30),
              _buildDescription(),
              Spacer(flex: 2),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: AppTextField(
                      enabled: false, controller: _textFieldController)),
              SizedBox(height: 30),
              ShareButton(
                onPressed: () => _pairingBloc.add(SendCodeEvent()),
                title: Strings.sendCodeText.toUpperCase(),
              ),
              Spacer(flex: 2),
              AppConfirmButton(
                  text: Strings.continueText.toUpperCase(),
                  arrowAssetPath: Assets.arrowForward,
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.nameScreen,
                      arguments: NameScreenArgs(isGenderChanged: false),
                    );
                  })
            ],
          );
      }),
    );
  }

  Widget _buildTitle() {
    return Text(
      Strings.yourCodeText.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: AppColors.blue,
        fontSize: 30,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        Strings.sendCodeDescriptionText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: AppColors.green,
        ),
      ),
    );
  }
}
