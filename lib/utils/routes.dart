import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/alerts/congratulations_screen.dart';
import 'package:what_is_my_name/alerts/match_screen.dart';
import 'package:what_is_my_name/alerts/reset_alert_screen.dart';
import 'package:what_is_my_name/app/app_bloc.dart';
import 'package:what_is_my_name/choose_gender_screen.dart';
import 'package:what_is_my_name/menu/menu_bloc.dart';
import 'package:what_is_my_name/menu/menu_state.dart';
import 'package:what_is_my_name/name/name_bloc.dart';
import 'package:what_is_my_name/name/name_screen.dart';
import 'package:what_is_my_name/name/name_state.dart';
import 'package:what_is_my_name/onboarding/onboarding_bloc.dart';
import 'package:what_is_my_name/onboarding/onboarding_screen.dart';
import 'package:what_is_my_name/onboarding/onboarding_state.dart';
import 'package:what_is_my_name/pairing/join_pairing_screen.dart';
import 'package:what_is_my_name/pairing/pairing_bloc.dart';
import 'package:what_is_my_name/pairing/pairing_screen.dart';
import 'package:what_is_my_name/pairing/pairing_state.dart';
import 'package:what_is_my_name/pairing/start_pairing_screen.dart';
import 'package:what_is_my_name/pairing/who_screen.dart';
import 'package:what_is_my_name/welcome_screen.dart';

import '../alerts/error_screen.dart';
import '../alerts/loading_screen.dart';
import '../container_screen.dart';

class Routes {
  static const String onboardingScreen = "onboarding-screen";
  static const String pairingScreen = "pairing-screen";
  static const String chooseGenderScreen = "choose-gender-screen";
  static const String nameScreen = "name-screen";
  static const String startPairingScreen = "start-pairing-screen";
  static const String joinPairingScreen = "join-pairing-screen";
  static const String congratulationsScreen = "congratulations-screen";
  static const String menuScreen = "menu-screen";
  static const String loadingScreen = "loading-screen";
  static const String errorScreen = "error-screen";
  static const String welcomeScreen = "welcome-screen";
  static const String whoScreen = "who-screen";
  static const String matchScreen = "match-screen";
  static const String myNamesScreen = "my-names-screen";
  static const String containerScreen = "container-screen";
  static const String resetAlertScreen = "reset-alert-screen";

  static Route chooseRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboardingScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: OnboardingBloc(OnboardingInitialState()),
            child: OnboardingScreen(),
          ),
        );
        break;
      case pairingScreen:
        return MaterialPageRoute(builder: (context) => PairingScreen());
        break;
      case chooseGenderScreen:
        return MaterialPageRoute(builder: (context) => ChooseGenderScreen());
        break;
      case nameScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: NameBloc(
                    NameInitialState(), BlocProvider.of<AppBloc>(context)),
                child: NameScreen(settings.arguments)));
        break;
      case resetAlertScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => MenuBloc(
                    MenuInitialState(), BlocProvider.of<AppBloc>(context)),
                child: ResetAlertScreen()));
        break;
      case joinPairingScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: PairingBloc(PairingInitialState()),
                child: JoinPairingScreen()));
        break;
      case startPairingScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: PairingBloc(PairingInitialState()),
                child: StartPairingScreen()));
        break;
      case congratulationsScreen:
        return MaterialPageRoute(
            builder: (context) => CongratulationsScreen(settings.arguments));
        break;
      case loadingScreen:
        return MaterialPageRoute(
            builder: (context) => LoadingScreen(settings.arguments));
        break;
      case errorScreen:
        return MaterialPageRoute(
            builder: (context) => ErrorScreen(settings.arguments));
        break;
      case matchScreen:
        return MaterialPageRoute(
            builder: (context) => MatchScreen(settings.arguments));
        break;
      case welcomeScreen:
        return MaterialPageRoute(builder: (context) => WelcomeScreen());
        break;
      case whoScreen:
        return MaterialPageRoute(builder: (context) => WhoScreen());
        break;
      case containerScreen:
        return MaterialPageRoute(
            builder: (context) => ContainerScreen(settings.arguments));
        break;
      default:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: OnboardingBloc(OnboardingInitialState()),
            child: OnboardingScreen(),
          ),
        );
        break;
    }
  }
}
