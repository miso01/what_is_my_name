import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_is_my_name/utils/assets.dart';

class BebeeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.bebee_logo,
        color: Colors.white, width: MediaQuery.of(context).size.width / 4);
  }
}
