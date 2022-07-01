import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what_is_my_name/models/name.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/sex_of_baby.dart';

class NameItem extends StatelessWidget {
  final Name name;
  final Function(int) onDismissed;

  const NameItem({this.name, this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(name),
      background: Container(
        color: AppColors.white,
        child:Row(
        children: <Widget>[
          Spacer(),
          SvgPicture.asset(Assets.binIcon, width: 20),
          SizedBox(width: 20),
        ],
      ),),
      direction: DismissDirection.endToStart,
      onDismissed:(direction) => onDismissed(name.id),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        color: name.gender == Gender.BOY
            ? AppColors.lightBlueButton
            : AppColors.lightPink,
        child: ListTile(
          title: Text(
            name.name.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
