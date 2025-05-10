import 'package:flutter/material.dart';

class AppDeviceUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double getScreenHeight() {
    return kToolbarHeight;
  }
}