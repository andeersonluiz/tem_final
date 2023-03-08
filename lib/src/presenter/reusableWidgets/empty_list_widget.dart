import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key, required this.msg});
  final String msg;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: fontFamily, fontSize: 20, color: Colors.white),
      ),
    );
  }
}
