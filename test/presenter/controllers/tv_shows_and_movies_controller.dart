// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';

import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tuple/tuple.dart';

import '../../domain/usecases/get_all_movie_usecase_test.dart';
import '../../domain/usecases/get_all_tv_show_and_movie_usecase_test.dart';
import '../../domain/usecases/get_all_tv_show_usecase_test.dart';
import '../../domain/usecases/get_tv_show_and_movie_usecase_test.dart';

class MockTvShowsAndMoviesController extends GetxController {
  MockTvShowsAndMoviesController(
    this._getAllTvShowAndMovieUseCase,
    this._getTvShowAndMovieUseCase,
    this._getAllMovieUseCase,
    this._getAllTvShowUseCase,
  );

  final MockGetAllTvShowAndMovieUseCase _getAllTvShowAndMovieUseCase;
  final MockGetTvShowAndMovieUseCase _getTvShowAndMovieUseCase;
  final MockGetAllMovieUseCase _getAllMovieUseCase;
  final MockGetAllTvShowUseCase _getAllTvShowUseCase;
  Rx<String> filterSelected = Filter.none.string.obs;
  RxList<Tuple2<String, List<TvShowAndMovie>>> listTvShowAndMovie =
      [Tuple2("", List<TvShowAndMovie>.empty())].obs;
  Rx<String> errorListTvShowAndMovie = "".obs;
  Rx<StatusLoadingTvShowAndMovie> statusLoadingTvSHowAndMovie =
      StatusLoadingTvShowAndMovie.firstRun.obs;
  Rx<int> indexSelected = 0.obs;
  getAllTvShowAndMovie() async {
    if (filterSelected.value == Filter.all.string) return;
    Future.microtask(() {
      _updateFilterSelected(Filter.all.string);
    });
    statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.loading;

    errorListTvShowAndMovie.value = "";
    await Future.delayed(const Duration(seconds: 2));
    DataState<List<Tuple2<String, List<TvShowAndMovie>>>>
        resultGetAllTvShowAndMovie = await _getAllTvShowAndMovieUseCase();
    if (resultGetAllTvShowAndMovie is DataSucess) {
      listTvShowAndMovie.assignAll(resultGetAllTvShowAndMovie.data!);
      statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.sucess;
    } else {
      statusLoadingTvSHowAndMovie.value = StatusLoadingTvShowAndMovie.error;
      errorListTvShowAndMovie.value = resultGetAllTvShowAndMovie.error!.item1;
    }
  }

  getAllMovie() async {
    if (filterSelected.value == Filter.movie.string) return;
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
    if (filterSelected.value == Filter.tvShow.string) return;
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

  _updateFilterSelected(String newFilter) {
    filterSelected.value = newFilter;
  }

  updateIndexSelected(int newIndex) {
    indexSelected.value = newIndex;
  }
}
