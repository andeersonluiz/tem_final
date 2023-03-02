import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/sub_overlay_icon.dart';

class SubItemResult extends StatelessWidget {
  const SubItemResult(
      {required this.text,
      required this.totalCount,
      required this.count,
      required this.icon1,
      required this.backgroundIcon1,
      required this.icon2,
      required this.backgroundIcon2,
      required this.isLastSeason,
      super.key});
  final String text;
  final int totalCount;
  final int count;
  final Icon icon1;
  final Color backgroundIcon1;
  final Icon icon2;
  final Color backgroundIcon2;
  final bool isLastSeason;
  @override
  Widget build(BuildContext context) {
    final percentage = count / totalCount;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: LinearPercentIndicator(
          lineHeight: 7.h,
          animation: true,
          animationDuration: 800,
          center: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                      text[0].toUpperCase() + text.substring(1).toLowerCase(),
                      maxLines: 2,
                      style: const TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                    "${(percentage.isNaN ? 0 : percentage * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                        fontFamily: fontFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          padding: const EdgeInsets.only(right: 16.0),
          barRadius: const Radius.circular(25),
          percent: percentage.isNaN ? 0 : percentage,
          backgroundColor: foregroundColor,
          progressColor: isLastSeason ? Colors.green[900] : Colors.grey,
          leading: SizedBox(
              height: 12.h,
              width: 20.w,
              child: SubOverlayIcon(
                icon1: icon1,
                backgroundIcon1: isLastSeason ? backgroundIcon1 : Colors.grey,
                icon2: icon2,
                backgroundIcon2: isLastSeason ? backgroundIcon2 : Colors.grey,
              ))),
    );
  }
}
