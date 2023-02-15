// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_by_genres_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';

import '../../domain/usecases/get_tv_show_and_movie_by_genres_usecase_test.dart';
import '../../domain/usecases/load_more_tv_show_and_movie_usecase_test.dart';

class MockGenreController extends GetxController {
  MockGenreController(
    this._getTvShowAndMovieByGenresUseCase,
    this._loadMoreTvShowAndMovieUseCase,
  );
  final MockGetTvShowAndMovieByGenresUseCase _getTvShowAndMovieByGenresUseCase;
  final MockLoadMoreTvShowAndMovieUseCase _loadMoreTvShowAndMovieUseCase;
}
