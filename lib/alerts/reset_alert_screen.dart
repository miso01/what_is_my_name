import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what_is_my_name/menu/menu_bloc.dart';
import 'package:what_is_my_name/menu/menu_event.dart';
import 'package:what_is_my_name/menu/menu_state.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_confirm_button.dart';

import 'error_screen.dart';
import 'loading_screen.dart';

class ResetAlertScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      listenWhen: (previousState, state ) => state is! ChooseGenderState && state is! ChangePartnerState,
      listener: (context, state) {
        if (state is ResetSuccessState) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacementNamed(context, Routes.welcomeScreen);
        } else if (state is ResetFailureState)
          Navigator.pushReplacementNamed(context, Routes.errorScreen,
              arguments: ErrorScreenArgs(state.message));
        else if (state is ResetInProgressState)
          Navigator.pushNamed(context, Routes.loadingScreen,
              arguments: LoadingScreenArgs(state.message));
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 60 + MediaQuery.of(context).padding.bottom),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width / 9),
                      color: AppColors.light,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.width / 6),
                          Container(
                            width: MediaQuery.of(context).size.width - 120,
                            child: AutoSizeText(
                              Strings.resetAppText.toUpperCase(),
                              maxLines: 1,
                              maxFontSize: 35,
                              minFontSize: 20,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                  fontSize: 35),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.only(left: 30, right: 30),
                            child: AutoSizeText(
                              Strings.resetAreYouSureText,
                              minFontSize: 18,
                              maxFontSize: 24,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30,
                                  color: AppColors.darkPurple),
                            ),
                          ),
                          Spacer(),
                          AppConfirmButton(
                              text: Strings.resetText.toUpperCase(),
                              onPressed: () => BlocProvider.of<MenuBloc>(context).add(ResetAppEvent())),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 9,
                        backgroundColor: AppColors.lightPink,
                        child: SvgPicture.asset(
                          Assets.errorIcon,
                          width: MediaQuery.of(context).size.width / 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


