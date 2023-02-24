import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.selectedText});
  final void Function()? onPressed;
  final String text;
  final String selectedText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: text == selectedText
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: optionFilledColor,
              ),
              child: Text(
                text,
                style: const TextStyle(
                    fontFamily: fontFamily,
                    color: textColorFilledOption,
                    fontSize: 16),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              child: Text(
                text,
                style: const TextStyle(
                    fontFamily: fontFamily,
                    color: optionFilledColor,
                    fontSize: 16),
              )),
    );
  }
}
