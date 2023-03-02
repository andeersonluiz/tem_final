// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdEvent extends Equatable {
  final BannerAd bannerAd;
  const AdEvent({
    required this.bannerAd,
  });

  @override
  List<Object?> get props => [bannerAd];
}

class UpdateBannerAd extends AdEvent {
  const UpdateBannerAd({required super.bannerAd});
}
