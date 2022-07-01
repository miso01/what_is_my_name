import 'package:flutter/material.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/sex_of_baby.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_confirm_button.dart';
import 'package:what_is_my_name/widgets/app_flex_button.dart';

import 'name/name_screen.dart';

class ChooseGenderScreen extends StatelessWidget {
  final SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.primaryGreen,
        title: Text(
          Strings.chooseGenderText.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.green,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          AppFlexButton(
            text: Strings.boyText,
            flex: 1,
            color: AppColors.lightBlueButton,
            onPressed: () async {
              _sharedPrefsRepository.saveChosenGender(Gender.BOY);
              final code = await _sharedPrefsRepository.getPairingCode();
              if (code == null || code.isEmpty)
                Navigator.pushNamed(context, Routes.whoScreen);
              else {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacementNamed(context, Routes.nameScreen,
                    arguments: NameScreenArgs(isGenderChanged: true));
              }
            },
          ),
          AppFlexButton(
              text: Strings.girlText,
              flex: 1,
              color: AppColors.lightPink,
              onPressed: () async {
                _sharedPrefsRepository.saveChosenGender(Gender.GIRL);
                final code = await _sharedPrefsRepository.getPairingCode();
                if (code == null || code.isEmpty)
                  Navigator.pushNamed(context, Routes.whoScreen);
                else {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, Routes.nameScreen,
                      arguments: NameScreenArgs(isGenderChanged: true));
                }
              }),
          AppFlexButton(
            text: Strings.doNotKnowText,
            flex: 1,
            color: AppColors.green,
            onPressed: () async {
              _sharedPrefsRepository.saveChosenGender(Gender.DO_NOT_KNOW);
              final code = await _sharedPrefsRepository.getPairingCode();
              if (code == null || code.isEmpty)
                Navigator.pushNamed(context, Routes.whoScreen);
              else {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacementNamed(context, Routes.nameScreen,
                    arguments: NameScreenArgs(isGenderChanged: true));
              }
            },
          ),
          !ModalRoute.of(context).isFirst
              ? AppConfirmButton(
                  text: Strings.backText.toUpperCase(),
                  arrowAssetPath: Assets.arrowBack,
                  onPressed: () => Navigator.of(context).pop(),
                )
              : Container()
        ],
      ),
    );
  }
}
