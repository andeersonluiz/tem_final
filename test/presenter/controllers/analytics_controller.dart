// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

import 'package:tem_final/src/domain/usecases/update_view_count_usecase.dart';

import '../../domain/usecases/update_view_count_usecase_test.dart';

class MockAnalyticsController extends GetxController {
  MockAnalyticsController(
    this._updateTvShowAndMovieViewViewCountUseCase,
  );
  final MockupdateTvShowAndMovieViewCountUseCase
      _updateTvShowAndMovieViewViewCountUseCase;
}
