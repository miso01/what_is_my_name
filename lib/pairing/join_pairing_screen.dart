import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/alerts/loading_screen.dart';
import 'package:what_is_my_name/app/app_bloc.dart';
import 'package:what_is_my_name/app/app_event.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_confirm_button.dart';
import 'package:what_is_my_name/widgets/app_text_field.dart';

import '../alerts/congratulations_screen.dart';
import '../alerts/error_screen.dart';
import 'pairing_bloc.dart';
import 'pairing_event.dart';
import 'pairing_state.dart';

class JoinPairingScreen extends StatefulWidget {
  @override
  _JoinPairingScreenState createState() => _JoinPairingScreenState();
}

class _JoinPairingScreenState extends State<JoinPairingScreen> {
  final TextEditingController _controller = TextEditingController();
  final SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();
  String _route;

  @override
  void didChangeDependencies() async {
    final gender = await _sharedPrefsRepository.getChosenGender();
    if (gender == null || gender == "")
      _route = Routes.chooseGenderScreen;
    else
      _route = Routes.nameScreen;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.primaryGreen,
      ),
      body: BlocConsumer<PairingBloc, PairingState>(listener: (context, state) {
        if (state is JoinPairingFailureState) {
          Navigator.pushNamed(context, Routes.errorScreen, arguments: ErrorScreenArgs(state.message));
        } else if (state is JoinPairingSuccessState) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacementNamed(
            context,
            Routes.congratulationsScreen,
            arguments: CongratulationsScreenArgs(
                state.message,
                _route),
          );
        }
      }, builder: (context, state) {
        if (state is PairingInProgressState)
          return LoadingScreen(
              LoadingScreenArgs(state.message));
        else
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 1),
              _buildTitle(),
              Spacer(flex: 2),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: AppTextField(
                  autofocus: true,
                  hint: Strings.enterA6DigitCodeText,
                  controller: _controller,
                ),
              ),
              Spacer(flex: 2),
              AppConfirmButton(
                  text: Strings.confirmText,
                  arrowAssetPath: Assets.arrowForward,
                  onPressed: () {
                    FocusManager.instance.primaryFocus.unfocus();
                    BlocProvider.of<PairingBloc>(context)
                        .add(JoinPairingEvent(_controller.text));
                  })
            ],
          );
      }),
    );
  }

  Widget _buildTitle() {
    return Text(
      Strings.enterCodeText.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: AppColors.blue,
        fontSize: 30,
      ),
    );
  }
}
