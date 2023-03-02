import 'package:flutter/material.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget(
      {super.key, required this.errorText, required this.onRefresh});
  final String errorText;
  final Future<void> Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: foregroundColor,
      color: Colors.white,
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Text(
                  errorText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
