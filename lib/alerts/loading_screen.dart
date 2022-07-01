import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/bebee_logo.dart';
import 'package:what_is_my_name/widgets/loading_rotating_widget.dart';

import '../utils/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  final LoadingScreenArgs args;

  const LoadingScreen(this.args);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top),
          Spacer(),
          _buildLoadingBackground(context),
          Spacer(flex: 2),
          _buildLoadingTitle(context),
          Spacer(flex: 1),
          _buildLoadingDescription(context),
          Spacer(flex: 2,),
          Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2.5),
              child: BebeeLogo()),
          Spacer(flex: 2,),
          SizedBox(height: 30),

        ],
      ),
    );
  }

  Widget _buildLoadingTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 5),
      child: AutoSizeText(
        Strings.weAreWorkingOnItText.toUpperCase(),
        minFontSize: 19,
        maxFontSize: 27,
        maxLines: 1,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 27, color: AppColors.blue),
      ),
    );
  }

  Widget _buildLoadingDescription(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width /4),
      child: AutoSizeText(
        args?.message ?? "" ,
        minFontSize: 14,
        maxFontSize: 22,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w300, fontSize: 22, color: AppColors.green),
      ),
    );
  }

  Widget _buildLoadingBackground(BuildContext context) {
    return Stack(fit: StackFit.loose, children: <Widget>[
      Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: SvgPicture.asset(Assets.loadingSplashedColor,
            width: MediaQuery.of(context).size.width),
      ),
      Positioned(
          bottom: 0,
          top: MediaQuery.of(context).padding.top + 20,
          left: MediaQuery.of(context).size.width / 4,
          right: MediaQuery.of(context).size.width / 4,
          child: LoadingRotatingWidget()),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(
            Assets.stork,
            width: MediaQuery.of(context).size.width / 1.9,
          ),
          Spacer(),
          Column(
            children: <Widget>[
              SizedBox(height: 70),
              SvgPicture.asset(
                Assets.stork,
                width: MediaQuery.of(context).size.width / 5,
              ),
            ],
          ),
        ],
      ),
      Positioned(
        bottom: 0,
        child: SvgPicture.asset(
          Assets.stork,
          width: MediaQuery.of(context).size.width / 3,
        ),
      ),
    ]);
  }
}

class LoadingScreenArgs {
  final String message;

  const LoadingScreenArgs(this.message);
}
