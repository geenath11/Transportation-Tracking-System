import 'package:flutter/material.dart';

class AppScale {
  static const double designWidth = 360.0;

  static double width(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return screenWidth / designWidth;
  }

  static double px(BuildContext context, double value) {
    return value * width(context);
  }
}
