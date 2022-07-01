import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:what_is_my_name/alerts/error_screen.dart';
import 'package:what_is_my_name/alerts/loading_screen.dart';
import 'package:what_is_my_name/onboarding/onboarding_bloc.dart';
import 'package:what_is_my_name/onboarding/onboarding_event.dart';
import 'package:what_is_my_name/onboarding/onboarding_first_page.dart';
import 'package:what_is_my_name/onboarding/onboarding_second_page.dart';
import 'package:what_is_my_name/onboarding/onboarding_state.dart';
import 'package:what_is_my_name/onboarding/onboarding_third_page.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/routes.dart';

import 'onboarding_fourth_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = new PageController();
  OnboardingBloc _onboardingBloc;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _onboardingBloc = BlocProvider.of<OnboardingBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
          listenWhen: (previousState, state) =>
              state is! OnboardingInitialState,
          listener: (context, state) {
            if (state is ShowNextPageState)
              _pageController.animateToPage(_pageController.page.round() + 1,
                  duration: new Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            else if (state is ShowPreviousPageState)
              _pageController.animateToPage(_pageController.page.round() - 1,
                  duration: new Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            else if (state is AuthSuccessState) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, Routes.chooseGenderScreen);
            } else if (state is AuthFailureState)
              Navigator.pushReplacementNamed(context, Routes.errorScreen,
                  arguments: ErrorScreenArgs(state.message));
            else if (state is AuthInProgressState)
              Navigator.pushNamed(context, Routes.loadingScreen,
                  arguments: LoadingScreenArgs(state.message));
          },
          buildWhen: (previousState, state) => state is OnboardingInitialState,
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                if (_pageController.page.round() < 3)
                  _onboardingBloc.add(ShowNextPageEvent());
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.primaryGreen,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        children: <Widget>[
                          OnboardingFirstPage(),
                          OnboardingSecondPage(),
                          OnboardingThirdPage(),
                          OnboardingFourthPage(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 25 +
                              (MediaQuery.of(context).padding.bottom * 0.5)),
                      child: SmoothPageIndicator(
                        controller: _pageController, // PageController
                        count: 4,
                        effect: WormEffect(
                            dotWidth: 12,
                            dotHeight: 12,
                            dotColor: AppColors.turquoise,
                            activeDotColor: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
