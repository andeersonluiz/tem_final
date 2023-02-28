import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'dart:math' as math;

class ContentItem extends StatelessWidget {
  const ContentItem(
      {super.key,
      required this.title,
      required this.leading,
      required this.onTap});
  final String title;
  final Widget leading;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: notFoundImageColor),
      child: ListTile(
          onTap: onTap,
          title: Text(title,
              style: const TextStyle(
                fontFamily: fontFamily,
                fontSize: 17,
                color: Colors.white,
              )),
          leading: leading),
    );
  }
}
