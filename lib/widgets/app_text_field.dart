import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:what_is_my_name/utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool enabled;
  final bool autofocus;

  AppTextField({this.hint = "", this.controller, this.enabled = true, this.autofocus=false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      enabled: enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        WhitelistingTextInputFormatter.digitsOnly
      ],
      controller: controller,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.blue,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint.toUpperCase(),
        hintStyle: TextStyle(
          color: AppColors.blue,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.green, width: 2.3),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.green, width: 2.3),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.green, width: 2.3),
        ),
      ),
    );
  }
}
