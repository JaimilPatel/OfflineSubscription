import 'package:flutter/widgets.dart';

class ScreenSizeConfig {
  ScreenSizeConfig._();
  static final ScreenSizeConfig _instance = ScreenSizeConfig._();

  factory ScreenSizeConfig() => _instance;

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static double getScaledValue(double value, BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return (value * mediaQueryData.textScaleFactor);
  }
}
