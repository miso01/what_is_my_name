import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/app/app_bloc.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/constants.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_flex_button.dart';

class WhoScreen extends StatelessWidget {
  final SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();

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
                  margin: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .padding
                          .top,
                      left: 30,
                      right: 30),
                  child:
                  Text(Strings.whoWillChooseNameForBabyText.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.blue,
                        fontSize: 30,
                      ),),
                ),
              ),
            ),
            AppFlexButton(
                text: Strings.onlyMeText,
                flex: 10,
                color: AppColors.lightBlueButton,
                onPressed: () async {
                  /// if user was connected with partner before we want
                  /// to remove connection code and partner user id
                  await _sharedPrefsRepository.savePairingCode(Constants.onlyMe);
                  await _sharedPrefsRepository.savePartnerUserId("");
                   BlocProvider.of<AppBloc>(context).stopPartnerLikedNamesSubscription();
                  final gender = await _sharedPrefsRepository.getChosenGender();
                  if (gender == null || gender == "") {
                    Navigator.pushNamed(context, Routes.chooseGenderScreen);
                  } else{
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacementNamed(context, Routes.nameScreen);
                  }
                }),
            AppFlexButton(
                text: Strings.withPartnerText,
                flex: 10,
                color: AppColors.lightPink,
                onPressed: () async{
                  await _sharedPrefsRepository.savePairingCode("");
                  await _sharedPrefsRepository.savePartnerUserId("");
                  Navigator.pushNamed(context, Routes.pairingScreen);
                }
            ),
          ],
        ),
      ),
    );
  }
}
