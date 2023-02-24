import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class SubSelectedIconCircle extends StatelessWidget {
  const SubSelectedIconCircle({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.selectedColor,
    required this.text,
    this.paddingSelectedColor = 8.0,
    this.textSize = 13,
    this.maxLines = 1,
  });
  final Widget icon;
  final Color backgroundColor;
  final Color selectedColor;
  final String text;
  final double paddingSelectedColor;
  final double textSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0), color: selectedColor),
      padding: EdgeInsets.all(paddingSelectedColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
            padding: const EdgeInsets.all(8.0),
            child: icon,
          ),
          SizedBox(
            width: 100.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AutoSizeText(
                text,
                textAlign: TextAlign.center,
                maxLines: maxLines,
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: textSize,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
