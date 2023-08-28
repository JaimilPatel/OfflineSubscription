import 'package:flutter/material.dart';
import 'package:offline_subscription/core/constant/pixel_size.dart';
import 'package:offline_subscription/core/constant/text_styles.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color backgroundColor;

  const ReusableButton(
      {required this.text,
      required this.onPressed,
      required this.textColor,
      required this.backgroundColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                PixelSize.value10,
              ),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
                horizontal: PixelSize.value40, vertical: PixelSize.value16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyles.getH4(
            textColor,
            FontWeight.w600,
            FontStyle.normal,
          ),
        ),
      );
}
