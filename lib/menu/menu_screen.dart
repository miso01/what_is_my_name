import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/alerts/error_screen.dart';
import 'package:what_is_my_name/alerts/loading_screen.dart';
import 'package:what_is_my_name/menu/menu_bloc.dart';
import 'package:what_is_my_name/menu/menu_event.dart';
import 'package:what_is_my_name/menu/menu_state.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/routes.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/menu_item.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    MenuBloc menuBloc = BlocProvider.of<MenuBloc>(context);
    return BlocListener<MenuBloc, MenuState>(
      listenWhen: (previousState, state) => state is ChooseGenderState || state is ChangePartnerState,
      listener: (context, state) {
        if (state is ChooseGenderState)
          Navigator.pushNamed(context, Routes.chooseGenderScreen);
        else if (state is ChangePartnerState)
          Navigator.pushNamed(context, Routes.whoScreen);
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              backgroundColor: AppColors.turquoise,
              automaticallyImplyLeading: false,
              elevation: 0,
              titleSpacing: 0,
              centerTitle: true,
              brightness: Brightness.dark,
              title: Column(
                children: [
                  Container(
                    color: AppColors.turquoise,
                    height: 15,
                  ),
                  MenuItem(
                    text: Strings.chooseGenderGeneralText.toUpperCase(),
                    color: AppColors.turquoise,
                    onPressed: () => menuBloc.add(ChooseGenderEvent()),
                  ),
                ],
              ),
            )),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              MenuItem(
                text: Strings.changePartnerText.toUpperCase(),
                color: AppColors.green,
                onPressed: () => menuBloc.add(ChangePartnerEvent()),
              ),
              MenuItem(
                  text: Strings.resetText.toUpperCase(),
                  color: AppColors.turquoise,
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.resetAlertScreen)),
            ],
          ),
        ),
      ),
    );
  }
}
