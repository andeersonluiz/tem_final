import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class SubUnselectedIconCircle extends StatelessWidget {
  const SubUnselectedIconCircle({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    required this.text,
    this.textSize = 15,
    this.maxLines = 1,
  });
  final void Function()? onTap;
  final Color backgroundColor;
  final String? text;
  final double textSize;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.0),
          color: backgroundColor.withOpacity(0.5)),
      child: InkWell(
        borderRadius: BorderRadius.circular(26.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: AutoSizeText(
                          text!,
                          maxLines: maxLines,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: textSize,
                              fontWeight: FontWeight.bold,
                              color: textColorInfoPageColor),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
