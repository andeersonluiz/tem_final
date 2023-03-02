import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';

class AdMobBanner extends StatefulWidget {
  const AdMobBanner({super.key, required this.bannerAd});
  final BannerAd? bannerAd;

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: WidgetSize.adBannerHeight,
        width: WidgetSize.adBannerWidth,
        child: widget.bannerAd == null ? null : AdWidget(ad: widget.bannerAd!),
      ),
    );
  }
}
