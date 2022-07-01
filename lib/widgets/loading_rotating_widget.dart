import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_is_my_name/utils/assets.dart';
import 'dart:math' as math;

class LoadingRotatingWidget extends StatefulWidget {
  @override
  _LoadingRotatingWidgetState createState() => _LoadingRotatingWidgetState();
}

class _LoadingRotatingWidgetState extends State<LoadingRotatingWidget>
    with TickerProviderStateMixin {
  AnimationController _rotationController;

  @override
  void initState() {
    _rotationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..repeat();
    super.initState();
  }
  
  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      child: SvgPicture.asset(Assets.loadingIcon,
          width: MediaQuery.of(context).size.width / 2.7),
      builder: (context, child) => Transform.rotate(
        angle: _rotationController.value * 2 * math.pi,
        child: child,
      ),
    );
  }
}
