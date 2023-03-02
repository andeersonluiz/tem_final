// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState extends Equatable {
  final BannerAd? bannerAd;
  const AdState({
    this.bannerAd,
  });

  @override
  List<Object> get props => [bannerAd ?? ""];
}

class UninitializedAd extends AdState {}

class LoadedAd extends AdState {
  const LoadedAd({required super.bannerAd});
}
