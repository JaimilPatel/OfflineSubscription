import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:offline_subscription/core/constant/pixel_size.dart';
import 'package:offline_subscription/core/constant/screen_size_config.dart';

class ProgressLoadingIndicator extends StatelessWidget {
  final List<Color>? colors;
  const ProgressLoadingIndicator({Key? key, this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return SizedBox(
        height: colors != null ? PixelSize.value25 : PixelSize.value40,
        width: colors != null ? PixelSize.value25 : PixelSize.value40,
        child: _loadingIndicator(context));
  }

  Widget _loadingIndicator(BuildContext context) => LoadingIndicator(
      indicatorType: Indicator.lineSpinFadeLoader,
      colors: colors ?? [Colors.red, Colors.black],
      strokeWidth: 2);
}
