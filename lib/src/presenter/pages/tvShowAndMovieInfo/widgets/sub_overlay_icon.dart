import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SubOverlayIcon extends StatelessWidget {
  const SubOverlayIcon(
      {super.key,
      required this.icon1,
      required this.backgroundIcon1,
      required this.icon2,
      required this.backgroundIcon2});
  final Icon icon1;
  final Color backgroundIcon1;
  final Icon icon2;
  final Color backgroundIcon2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: backgroundIcon1),
                child: icon1),
          ),
        ),
        Positioned(
          top: 5.5.h,
          left: 9.w,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundIcon2,
                ),
                child: icon2),
          ),
        )
      ],
    );
  }
}
