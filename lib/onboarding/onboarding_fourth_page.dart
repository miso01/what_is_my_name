import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/strings.dart';

import 'onboarding_bloc.dart';
import 'onboarding_event.dart';


class OnboardingFourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 7),
          child: AutoSizeText(
            Strings.mistakeQuestionText.toUpperCase(),
            maxLines: 1,
            maxFontSize: 40,
            minFontSize: 20,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 40,
                color: AppColors.blue),
          ),
        ),
        Spacer(),
        SvgPicture.asset(
          Assets.fourthOnboardingImage,
          width: MediaQuery.of(context).size.width - 30,
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 7),
          child: AutoSizeText(
            Strings.shakeToUndoText,
            minFontSize: 16,
            maxFontSize: 27,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.darkPurple,
                fontWeight: FontWeight.w300,
                fontSize: 27),
          ),
        ),
        Spacer(),
        _buildBeginButton(context),
        Spacer()
      ],
    );
  }

  Widget _buildBeginButton(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: FlatButton(
        color: AppColors.white,
        onPressed: () =>
            BlocProvider.of<OnboardingBloc>(context).add(SignInAnonymouslyEvent()),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            Strings.weBeginText.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlue,
                fontSize: 14 * MediaQuery.of(context).size.height * 0.002),
          ),
        ),
      ),
    );
  }
}
