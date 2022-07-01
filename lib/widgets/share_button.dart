import 'package:flutter/material.dart';
import 'package:what_is_my_name/utils/app_colors.dart';

class ShareButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String title;


  const ShareButton({@required this.onPressed, @required this.title});

  @override
  Widget build(BuildContext context) {
     return Align(
      alignment: Alignment.topCenter,
      child: FlatButton(
        color: AppColors.white,
        onPressed: () => onPressed(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.share, color: AppColors.primaryBlue),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
