import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/set_tv_serie_and_movie_with_favorite_usecase.dart';

class FavoriteController extends GetxController {
  FavoriteController(
    this._setTvSerieAndMovieWithFavoriteUseCase,
  );
  final SetTvSerieAndMovieWithFavoriteUseCase
      _setTvSerieAndMovieWithFavoriteUseCase;
}
