import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_confirm_button.dart';

import '../models/name.dart';

class MatchScreen extends StatelessWidget {
  final MatchScreenArgs args;

  const MatchScreen(this.args);

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
                        top: MediaQuery.of(context).size.width / 7.5),
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width / 7),
                    color: AppColors.light,
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        _buildName(),
                        Spacer(),
                        _buildMatchText(),
                        Spacer(),
                        _buildCongratulationsText(),
                        Spacer(),
                        AppConfirmButton(
                          text: Strings.okText.toUpperCase(),
                          color: AppColors.green,
                          textColor: AppColors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  _buildMatchIcon(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        args.name.name,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.darkPurple,
            fontSize: 26),
      ),
    );
  }

  Widget _buildMatchText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: Strings.superText.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
              fontSize: 20,
            ),
            children: [
              TextSpan(
                  text: Strings.bothPartnersLikeThisNameText.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.blue,
                      fontSize: 20))
            ]),
      ),
    );
  }

  Widget _buildCongratulationsText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        Strings.congratulationsMatchText,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: AppColors.darkPurple),
      ),
    );
  }

  Widget _buildMatchIcon(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SvgPicture.asset(
        Assets.matchIcon,
        width: MediaQuery.of(context).size.width / 3.5,
      ),
    );
  }
}

class MatchScreenArgs {
  final Name name;

  const MatchScreenArgs(this.name);
}
