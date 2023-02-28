import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.selectedText,
      this.colorSelected,
      this.colorUnselected,
      this.padding =
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)});
  final void Function()? onPressed;
  final String text;
  final String selectedText;
  final Color? colorSelected;
  final Color? colorUnselected;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: text == selectedText
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorSelected ?? optionFilledColor,
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
                  side:
                      BorderSide(color: colorUnselected ?? Colors.transparent)),
              child: Text(
                text,
                style: TextStyle(
                    fontFamily: fontFamily,
                    color: colorUnselected ?? optionFilledColor,
                    fontSize: 16),
              )),
    );
  }
}
