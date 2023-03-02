import 'package:bloc/bloc.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_main_page_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_state.dart';
import 'package:tuple/tuple.dart';

class TvShowAndMovieBloc
    extends Bloc<TvShowAndMovieEvent, TvShowAndMovieState> {
  TvShowAndMovieBloc(
      this._getAllTvShowAndMovieUseCase,
      this._getAllMovieUseCase,
      this._getAllTvShowUseCase,
      this._loadMoreTvShowAndMovieMainPageUseCase)
      : super(TvShowAndMovieLoading(Filter.all)) {
    on<GetAllTvShowAndMovieEvent>(_getAllTvShowsAndMovies);
    on<GetAllMovieEvent>(_getAllMovies);
    on<GetAllTvShowEvent>(_getAllTvShoW);
    on<LoadingMoreEvent>(_loadMore);
  }
  final GetAllTvShowAndMovieUseCase _getAllTvShowAndMovieUseCase;
  final GetAllMovieUseCase _getAllMovieUseCase;
  final GetAllTvShowUseCase _getAllTvShowUseCase;
  final LoadMoreTvShowAndMovieMainPageUseCase
      _loadMoreTvShowAndMovieMainPageUseCase;

  Filter? filterSelected;
  bool isLoadingMore = false;
  bool isFinalList = false;
  /* Rx<String> errorListTvShowAndMovie = "".obs;
Rx<StatusLoadingTvShowAndMovie> statusLoadingTvSHowAndMovie =
      StatusLoadingTvShowAndMovie.firstRun.obs;
  Rx<int> indexSelected = 0.obs;*/
  List<Tuple2<GenreType, List<TvShowAndMovie>>> listTvShowAndMovie = [
    Tuple2(GenreType.none, List<TvShowAndMovie>.empty())
  ];

  Future<void> _getAllTvShowsAndMovies(GetAllTvShowAndMovieEvent event,
      Emitter<TvShowAndMovieState> emit) async {
    final Filter filter = filterSelected ?? Filter.all;
    if (filterSelected == filter && !event.refresh) return;
    filterSelected = filter;
    isFinalList = false;
    emit(TvShowAndMovieLoading(filter));
    DataState<List<Tuple2<GenreType, List<TvShowAndMovie>>>>
        resultGetAllTvShowAndMovie = await _getAllTvShowAndMovieUseCase();
    if (resultGetAllTvShowAndMovie is DataSucess) {
      listTvShowAndMovie = resultGetAllTvShowAndMovie.data!;
      emit(TvShowAndMovieDone(listTvShowAndMovie, filter));
    } else {
      emit(
          TvShowAndMovieError(resultGetAllTvShowAndMovie.error!.item1, filter));
    }
  }

  void _getAllMovies(
      GetAllMovieEvent event, Emitter<TvShowAndMovieState> emit) async {
    const Filter filter = Filter.movie;
    if (filterSelected == filter && !event.refresh) return;

    filterSelected = filter;
    isFinalList = false;
    emit(TvShowAndMovieLoading(filter));
    DataState<List<Tuple2<GenreType, List<TvShowAndMovie>>>>
        resultGetAllTvShowAndMovie = await _getAllMovieUseCase();
    if (resultGetAllTvShowAndMovie is DataSucess) {
      listTvShowAndMovie = resultGetAllTvShowAndMovie.data!;

      emit(TvShowAndMovieDone(listTvShowAndMovie, filter));
    } else {
      emit(
          TvShowAndMovieError(resultGetAllTvShowAndMovie.error!.item1, filter));
    }
  }

  void _getAllTvShoW(
      GetAllTvShowEvent event, Emitter<TvShowAndMovieState> emit) async {
    const Filter filter = Filter.tvShow;
    if (filterSelected == filter && !event.refresh) return;
    filterSelected = filter;
    isFinalList = false;

    emit(TvShowAndMovieLoading(filter));
    DataState<List<Tuple2<GenreType, List<TvShowAndMovie>>>>
        resultGetAllTvShowAndMovie = await _getAllTvShowUseCase();
    if (resultGetAllTvShowAndMovie is DataSucess) {
      listTvShowAndMovie = resultGetAllTvShowAndMovie.data!;

      emit(TvShowAndMovieDone(listTvShowAndMovie, filter));
    } else {
      emit(
          TvShowAndMovieError(resultGetAllTvShowAndMovie.error!.item1, filter));
    }
  }

  void _loadMore(
      LoadingMoreEvent event, Emitter<TvShowAndMovieState> emit) async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    Filter filter = Filter.values
        .where((element) => event.filterSelected == element.string)
        .first;
    DataState<List<Tuple2<GenreType, List<TvShowAndMovie>>>>
        resultGetAllTvShowAndMovie =
        await _loadMoreTvShowAndMovieMainPageUseCase(filter);
    if (resultGetAllTvShowAndMovie is DataSucess) {
      if (resultGetAllTvShowAndMovie.data!.isEmpty) {
        isLoadingMore = false;
        isFinalList = true;
        return;
      }
      listTvShowAndMovie = [
        ...listTvShowAndMovie,
        ...resultGetAllTvShowAndMovie.data!
      ];
      emit(TvShowAndMovieDone(listTvShowAndMovie, filter));
    } else {
      emit(
          TvShowAndMovieError(resultGetAllTvShowAndMovie.error!.item1, filter));
    }

    isLoadingMore = false;
  }
}
