import 'package:flutter/material.dart';
import 'package:what_is_my_name/utils/app_colors.dart';

class AppFlexButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int flex;
  final Color color;

  AppFlexButton(
      {@required this.text,
      @required this.flex,
      @required this.color,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: Container(
        width: double.infinity,
        color: color,
        child: FlatButton(
          onPressed: () => onPressed(),
          child: Text(text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  fontSize: 30)),
        ),
      ),
    );
  }
}
