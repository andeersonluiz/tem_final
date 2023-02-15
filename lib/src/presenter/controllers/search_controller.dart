// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/search_tv_show_and_movie_usecase.dart';

class SearchController extends GetxController {
  SearchController(
    this._searchTvShowAndMovieUseCase,
    this._loadMoreTvShowAndMovieUseCase,
  );
  final SearchTvShowAndMovieUseCase _searchTvShowAndMovieUseCase;
  final LoadMoreTvShowAndMovieUseCase _loadMoreTvShowAndMovieUseCase;
}
