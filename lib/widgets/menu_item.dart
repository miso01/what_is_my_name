import 'package:flutter/material.dart';
import 'package:what_is_my_name/utils/app_colors.dart';

class MenuItem extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;

  const MenuItem({this.onPressed, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      color: color,
      child: ListTile(
        onTap: () => onPressed(),
        title: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
