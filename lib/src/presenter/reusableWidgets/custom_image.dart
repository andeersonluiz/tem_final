import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
      {super.key,
      this.width,
      this.height,
      this.errorWidget,
      required this.urlImage,
      this.fit,
      this.placeholderPath = "assets/placeholderImage.gif"});
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final String urlImage;
  final String placeholderPath;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 400),
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        errorWidget: (context, string, url) {
          return errorWidget ??
              Container(
                color: notFoundImageColor,
              );
        },
        imageUrl: urlImage,
        placeholder: (context, url) => Container(
              color: ratingColorPosterMainPage,
              child: Image.asset(
                placeholderPath,
                width: width,
                height: height,
                fit: BoxFit.fill,
              ),
            ));
  }
}
