import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_confirm_button.dart';
import 'package:what_is_my_name/widgets/bebee_logo.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          BebeeLogo(),
          Spacer(flex: 1),
          _buildAppName(context),
          _buildDescription(context),
          Spacer(flex: 2),
          _buildImage(context),
          AppConfirmButton(
              arrowAssetPath: Assets.arrowForward,
              text: Strings.letsGoText.toUpperCase(),
              onPressed: () => Navigator.pushNamed(context, Routes.onboardingScreen))
        ],
      ),
    );
  }

  Widget _buildAppName(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 7),
      child: AutoSizeText(
        Strings.whatIsMyNameText.toUpperCase(),
        maxLines: 2,
        minFontSize: 15,
        maxFontSize: 70,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: AppColors.primaryBlue,
          fontSize: 70
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 7),
      child: AutoSizeText(
        Strings.findNameForYourBabyText,
        textAlign: TextAlign.center,
        minFontSize: 16,
        maxFontSize: 30,
        maxLines: 2,
        style: TextStyle(
            fontWeight: FontWeight.w300,
            color: AppColors.primaryBlue,
            fontSize: 30),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SvgPicture.asset(
          Assets.welcomeImage,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }
}
