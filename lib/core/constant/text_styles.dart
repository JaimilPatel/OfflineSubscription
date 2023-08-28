import 'package:flutter/material.dart';
import 'package:offline_subscription/core/constant/app_constant.dart';
import 'pixel_size.dart';

class TextStyles {
  static TextStyle getH0(
          Color color, FontWeight fontWeight, FontStyle fontStyle) =>
      TextStyle(
          fontFamily: AppConstant.poppinsFontFamily,
          fontSize: PixelSize.h0,
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle);

  static TextStyle getH4(
          Color color, FontWeight fontWeight, FontStyle fontStyle) =>
      TextStyle(
          fontFamily: AppConstant.poppinsFontFamily,
          fontSize: PixelSize.h4,
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle);

  static TextStyle getH7(
          Color color, FontWeight fontWeight, FontStyle fontStyle) =>
      TextStyle(
          fontFamily: AppConstant.poppinsFontFamily,
          fontSize: PixelSize.h7,
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle);
}
