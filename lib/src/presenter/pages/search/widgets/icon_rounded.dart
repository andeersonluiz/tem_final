import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class IconRounded extends StatelessWidget {
  const IconRounded(
      {super.key,
      required this.icon,
      required this.backgroundColor,
      required this.text});
  final Icon icon;
  final Color backgroundColor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        padding: const EdgeInsets.all(8.0),
        child: icon,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text[0].toUpperCase() + text.substring(1).toLowerCase(),
          style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 13,
              color: backgroundColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}
