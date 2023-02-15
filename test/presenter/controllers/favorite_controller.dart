import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/set_tv_serie_and_movie_with_favorite_usecase.dart';

import '../../domain/usecases/set_tv_serie_and_movie_with_favorite_usecase_test.dart';

class MockFavoriteController extends GetxController {
  MockFavoriteController(
    this._setTvSerieAndMovieWithFavoriteUseCase,
  );
  final MockSetTvSerieAndMovieWithFavoriteUseCase
      _setTvSerieAndMovieWithFavoriteUseCase;
}
