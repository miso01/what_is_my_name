import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/strings.dart';

class OnboardingThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 7),
          child: AutoSizeText(
            Strings.likeOrDislikeText.toUpperCase(),
            maxLines: 2,
            maxFontSize: 40,
            minFontSize: 20,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 40, color: AppColors.blue),
          ),
        ),
        Spacer(),
        SvgPicture.asset(
          Assets.thirdOnboardingImage,
          width: MediaQuery.of(context).size.width - 30,
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 7),
          child: AutoSizeText(
            Strings.likeSwipeLeftDislikeSwipeRightText,
            maxLines: 4,
            minFontSize: 16,
            maxFontSize: 27,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.darkPurple,
                fontWeight: FontWeight.w300,
                fontSize: 27),
          ),
        ),
        Spacer()
      ],
    );
  }
}
