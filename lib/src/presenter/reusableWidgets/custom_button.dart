import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.fontSize = 16,
      this.disabledColor,
      this.backgroundColor});
  final void Function()? onPressed;
  final String text;
  final double fontSize;
  final Color? backgroundColor;
  final Color? disabledColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(), disabledBackgroundColor: disabledColor,
        backgroundColor:
            backgroundColor ?? ratingColorPosterMainPage, //<-- SEE HERE
      ),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: fontFamily,
            color: textColorFilledOption,
            fontSize: fontSize),
      ),
    );
  }
}
