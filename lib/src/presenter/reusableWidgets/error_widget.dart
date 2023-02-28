import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.errorText});
  final String errorText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorText,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: fontFamily, fontSize: 20, color: Colors.white),
      ),
    );
  }
}
