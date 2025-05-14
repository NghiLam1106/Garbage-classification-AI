import 'package:flutter/material.dart';
import 'package:garbageClassification/common/constants/appSizes.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({super.key, this.child, this.width, this.height, this.radius = AppSizes.cardRadiusLg, this.showBorder = false, this.backgroundColor = Colors.white, this.borderColor = Colors.blueAccent, this.padding, this.margin});

  final Widget? child;
  final double? width;
  final double? height;
  final double radius;
  final bool showBorder;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}