import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class TitleItem extends StatelessWidget {
  const TitleItem({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 18.0,
        bottom: 8.0,
      ),
      child: Text(title,
          style: const TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w400)),
    );
  }
}
