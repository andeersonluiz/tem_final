import 'package:bloc/bloc.dart';

import 'ad_event.dart';
import 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  AdBloc() : super(UninitializedAd()) {
    on<UpdateBannerAd>(_updateBannerAd);
  }

  Future<void> _updateBannerAd(
      UpdateBannerAd event, Emitter<AdState> emit) async {
    emit(LoadedAd(bannerAd: event.bannerAd));
  }
}
