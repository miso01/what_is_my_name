import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_is_my_name/my_names/my_names_bloc.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/widgets/app_button.dart';

import 'app/app_bloc.dart';
import 'menu/menu_bloc.dart';
import 'menu/menu_screen.dart';
import 'menu/menu_state.dart';
import 'my_names/my_names_screen.dart';
import 'my_names/my_names_state.dart';

class ContainerScreen extends StatefulWidget {
  final ContainerScreenArgs args;

  const ContainerScreen(this.args);

  @override
  _ContainerScreenState createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  int _selectedIndex;

  final _screens = [
    BlocProvider<MenuBloc>(
        create: (context) =>
            MenuBloc(MenuInitialState(), BlocProvider.of<AppBloc>(context)),
        child: MenuScreen()),
    BlocProvider<MyNamesBloc>(
      create: (context) =>
          MyNamesBloc(MyNamesInitialState(), BlocProvider.of<AppBloc>(context)),
      child: MyNamesScreen(),
    ),
  ];

  @override
  void didChangeDependencies() {
    _selectedIndex = widget.args.pageIndex;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: Row(
        children: <Widget>[
          AppButton(
            text: Strings.backText,
            color: _selectedIndex == 0 ? AppColors.light : AppColors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton(
              text: Strings.myText,
              widget: Row(
                children: [
                  SizedBox(width: 8),
                  SvgPicture.asset(
                    Assets.heartIcon,
                    width: 17,
                  ),
                ],
              ),
              color: _selectedIndex == 1 ? AppColors.light : AppColors.white,
              onPressed: () => setState(() => _selectedIndex = 1))
        ],
      ),
    );
  }
}

class ContainerScreenArgs {
  final int pageIndex;

  const ContainerScreenArgs(this.pageIndex);
}
