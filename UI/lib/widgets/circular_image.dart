import 'package:flutter/material.dart';
import 'package:garbageClassification/common/constants/appSizes.dart';

class CircularImages extends StatelessWidget {
  const CircularImages({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = AppSizes.sm,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (Colors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image(
        fit: fit,
        image: isNetworkImage? NetworkImage(image) :AssetImage(image),
        color: overlayColor,
      ),
    );
  }
}