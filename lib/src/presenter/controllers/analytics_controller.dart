// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

import 'package:tem_final/src/domain/usecases/update_view_count_usecase.dart';

class AnalyticsController extends GetxController {
  AnalyticsController(
    this._updateTvShowAndMovieViewViewCountUseCase,
  );
  final UpdateTvShowAndMovieViewCountUseCase
      _updateTvShowAndMovieViewViewCountUseCase;

  updateViewCount(String idTvShowAndMovie) async {
    await _updateTvShowAndMovieViewViewCountUseCase(idTvShowAndMovie);
  }
}
