import 'package:flutter/material.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_flex_button.dart';

class PairingScreen extends StatefulWidget {
  @override
  _PairingScreenState createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 11,
              fit: FlexFit.tight,
              child: Center(
                child: Container(
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child:
                      Text(Strings.isBetterToChooseNameAsACouple.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue,
                            fontSize: 30,
                          )),
                ),
              ),
            ),
            AppFlexButton(
              text: Strings.sendCodeText,
              flex: 10,
              color: AppColors.lightBlueButton,
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.startPairingScreen),
            ),
            AppFlexButton(
              text: Strings.enterCodeText,
              flex: 10,
              color: AppColors.lightPink,
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.joinPairingScreen),
            )
          ],
        ),
      ),
    );
  }
}
