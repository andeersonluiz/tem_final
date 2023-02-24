import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({this.color = optionFilledColor, super.key});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: color,
        ));
  }
}
