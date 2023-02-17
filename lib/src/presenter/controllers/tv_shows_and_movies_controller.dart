// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';

import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_main_page_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tuple/tuple.dart';

class TvShowsAndMoviesController extends GetxController {
  TvShowsAndMoviesController(
    this._getAllTvShowAndMovieUseCase,
    this._loadMoreTvShowAndMovieMainPageUseCase,
    this._getAllMovieUseCase,
    this._getAllTvShowUseCase,
  );

  final GetAllTvShowAndMovieUseCase _getAllTvShowAndMovieUseCase;
  final GetAllMovieUseCase _getAllMovieUseCase;
  final GetAllTvShowUseCase _getAllTvShowUseCase;
  final LoadMoreTvShowAndMovieMainPageUseCase
      _loadMoreTvShowAndMovieMainPageUseCase;
  Rx<String> filterSelected = Filter.all.string.obs;
  RxList<Tuple2<String, List<TvShowAndMovie>>> listTvShowAndMovie =
      [Tuple2("", List<TvShowAndMovie>.empty())].obs;
  Rx<String> errorListTvShowAndMovie = "".obs;
  Rx<StatusLoadingTvShowAndMovie> statusLoadingTvSHowAndMovie =
      StatusLoadingTvShowAndMovie.firstRun.obs;
  Rx<int> indexSelected = 0.obs;
  bool isLoadingMore = false;
  getAllTvShowAndMovie() async {
    if (filterSelected.value == Filter.all.string ||
        statusLoadingTvSHowAndMovie.value ==
            StatusLoadingTvShowAndMovie.loading) return;

    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();

    Future.microtask(() {
      _updateFilterSelected(Filter.all.string);
    });
    statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.loading;

    errorListTvShowAndMovie.value = "";
    stopwatch.stop();
    print(
        'Cronómetro03 detenido después de ${stopwatch.elapsedMilliseconds} milisegundos');
    stopwatch.start();
    DataState<List<Tuple2<String, List<TvShowAndMovie>>>>
        resultGetAllTvShowAndMovie = await _getAllTvShowAndMovieUseCase();
    stopwatch.stop();
    print(
        'Cronómetro04 detenido después de ${stopwatch.elapsedMilliseconds} milisegundos');

    if (resultGetAllTvShowAndMovie is DataSucess) {
      listTvShowAndMovie.assignAll(resultGetAllTvShowAndMovie.data!);
      statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.sucess;
    } else {
      statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.error;
      errorListTvShowAndMovie.value = resultGetAllTvShowAndMovie.error!.item1;
    }
  }

  getAllMovie() async {
    if (filterSelected.value == Filter.movie.string ||
        statusLoadingTvSHowAndMovie.value ==
            StatusLoadingTvShowAndMovie.loading) return;
    Future.microtask(() {
      _updateFilterSelected(Filter.movie.string);
    });
    statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.loading;
    await Future.delayed(const Duration(seconds: 2));
    errorListTvShowAndMovie.value = "";
    DataState<List<Tuple2<String, List<TvShowAndMovie>>>>
        resultGetAllTvShowAndMovie = await _getAllMovieUseCase();
    if (resultGetAllTvShowAndMovie is DataSucess) {
      statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.sucess;

      listTvShowAndMovie.assignAll(resultGetAllTvShowAndMovie.data!);
    } else {
      statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.error;
      errorListTvShowAndMovie.value = resultGetAllTvShowAndMovie.error!.item1;
    }
  }

  getAllTvShow() async {
    if (filterSelected.value == Filter.tvShow.string ||
        statusLoadingTvSHowAndMovie.value ==
            StatusLoadingTvShowAndMovie.loading) return;
    Future.microtask(() {
      _updateFilterSelected(Filter.tvShow.string);
    });
    statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.loading;

    errorListTvShowAndMovie.value = "";
    await Future.delayed(const Duration(seconds: 2));
    DataState<List<Tuple2<String, List<TvShowAndMovie>>>>
        resultGetAllTvShowAndMovie = await _getAllTvShowUseCase();
    if (resultGetAllTvShowAndMovie is DataSucess) {
      statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.sucess;
      listTvShowAndMovie.assignAll(resultGetAllTvShowAndMovie.data!);
    } else {
      statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.error;
      errorListTvShowAndMovie.value = resultGetAllTvShowAndMovie.error!.item1;
    }
  }

  loadMore() async {
    isLoadingMore = true;
    var resultLoadingMore = await _loadMoreTvShowAndMovieMainPageUseCase(
        _getPaginationTypeByFilter());
    if (resultLoadingMore is DataSucess) {
      print(resultLoadingMore.data!.length);
      listTvShowAndMovie.addAll(resultLoadingMore.data!.toList());
    }
    isLoadingMore = false;
  }

  _getPaginationTypeByFilter() {
    Filter filter =
        Filter.values.firstWhere((e) => e.string == filterSelected.value);
    print(filter);
    switch (filter) {
      case Filter.all:
        return PaginationTypeMainPage.all;
      case Filter.movie:
        return PaginationTypeMainPage.movie;
      case Filter.tvShow:
        return PaginationTypeMainPage.tvShow;
    }
  }

  _updateFilterSelected(String newFilter) {
    filterSelected.value = newFilter;
  }

  updateIndexSelected(int newIndex) {
    indexSelected.value = newIndex;
  }
}
