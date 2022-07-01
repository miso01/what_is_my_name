import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'package:what_is_my_name/utils/strings.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;
  final Widget widget;


  const AppButton({@required this.onPressed, @required this.color, @required this.text, this.widget});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60 + (MediaQuery.of(context).padding.bottom / 2),
        color: color,
        child: FlatButton(
          onPressed: () => onPressed(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text.toUpperCase(),
                style: TextStyle(
                    color: AppColors.darkPurple,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              widget != null ? widget : SizedBox() ,
            ],
          ),
        ),
      ),
    );
  }
}
