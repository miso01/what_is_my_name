import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_confirm_button.dart';

class CongratulationsScreen extends StatelessWidget {
  final CongratulationsScreenArgs args;

  const CongratulationsScreen(this.args);

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 1),
            SvgPicture.asset(Assets.congratulationsLogo,
                width: MediaQuery.of(context).size.width / 3),
            Spacer(flex: 2),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Text(Strings.congratulationsText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.blue,
                    fontSize: 30,
                  )),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                args.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: AppColors.green,
                ),
              ),
            ),
            Spacer(flex: 2),
            AppConfirmButton(
              text: Strings.beginText,
              arrowAssetPath: Assets.arrowForward,
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, args.route),
            )
          ]),
    );
  }
}

class CongratulationsScreenArgs {
  final String message;
  final String route;

  const CongratulationsScreenArgs(this.message, this.route);
}
