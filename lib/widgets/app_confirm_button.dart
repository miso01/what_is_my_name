import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what_is_my_name/utils/app_colors.dart';
import 'package:what_is_my_name/utils/assets.dart';

class AppConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String arrowAssetPath;
  final Color color;
  final Color textColor;

  AppConfirmButton(
      {@required this.text,
      @required this.onPressed,
      this.arrowAssetPath,
      this.color = AppColors.white,
      this.textColor = AppColors.darkPurple});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 + (MediaQuery.of(context).padding.bottom / 2),
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        onPressed: () => onPressed(),
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            arrowAssetPath == Assets.arrowBack
                ? Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(
                      Assets.arrowBack,
                      height: 15,
                    ),
                  )
                : SizedBox(),
            Text(
              text.toUpperCase(),
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.w500, fontSize: 20),
            ),
            arrowAssetPath == Assets.arrowForward
                ? Container(
                    margin: EdgeInsets.only(left: 10),
                    child: SvgPicture.asset(
                      Assets.arrowForward,
                      height: 15,
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
