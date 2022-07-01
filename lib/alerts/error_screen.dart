import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_confirm_button.dart';

class ErrorScreen extends StatelessWidget {
  final ErrorScreenArgs args;

  const ErrorScreen(this.args);

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
                        top: MediaQuery.of(context).size.width / 9),
                    color: AppColors.light,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.width / 6),
                        Container(
                          width: MediaQuery.of(context).size.width - 120,
                          child: AutoSizeText(
                            Strings.errorOccurredText.toUpperCase(),
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
                          child: Text(
                            args?.errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: AppColors.darkPurple),
                          ),
                        ),
                        Spacer(),
                        AppConfirmButton(
                          text: Strings.okText.toUpperCase(),
                          onPressed: () => Navigator.pop(context),
                        ),
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
    );
  }
}

class ErrorScreenArgs {
  final String errorMessage;

  const ErrorScreenArgs(this.errorMessage);
}
