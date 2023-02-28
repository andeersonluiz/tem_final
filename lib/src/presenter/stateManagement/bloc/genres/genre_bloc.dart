import 'package:bloc/bloc.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/usecases/filter_genres_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_by_genres_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/genres/genre_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/genres/genre_state.dart';
import 'package:tuple/tuple.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc(this._getTvShowAndMovieByGenresUseCase, this._filterGenresUseCase,
      this._loadMoreTvShowAndMovieGenrePageUseCase)
      : super(const GenreLoading(
            listTvShowAndMovie: [],
            msg: "",
            filters: Tuple2(Filter.all, FilterGenre.popularity))) {
    on<GetGenreEvent>(_getGenres);
    on<FilterGenreEvent>(_filterGenres);
    on<LoadMoreGenreEvent>(_loadMoreGenres);
  }

  final GetTvShowAndMovieByGenresUseCase _getTvShowAndMovieByGenresUseCase;
  final FilterGenresUseCase _filterGenresUseCase;
  final LoadMoreTvShowAndMovieGenrePageUseCase
      _loadMoreTvShowAndMovieGenrePageUseCase;
  bool isLoadingMore = false;
  bool isFinalList = false;
  Future<void> _getGenres(GetGenreEvent event, Emitter<GenreState> emit) async {
    emit(GenreLoading(listTvShowAndMovie: [], msg: '', filters: state.filters));
    var result = await _getTvShowAndMovieByGenresUseCase([event.genreType!]);
    if (result is DataSucess) {
      emit(GenreDone(
          listTvShowAndMovie: result.data!, msg: '', filters: state.filters));
    } else {
      emit(GenreError(
          listTvShowAndMovie: [],
          msg: result.error!.item1,
          filters: state.filters));
    }
  }

  Future<void> _filterGenres(
      FilterGenreEvent event, Emitter<GenreState> emit) async {
    emit(GenreLoading(listTvShowAndMovie: [], msg: '', filters: state.filters));
    var result = await _filterGenresUseCase(event.filters!);

    if (result is DataSucess) {
      emit(GenreDone(
          listTvShowAndMovie: result.data!, msg: '', filters: event.filters!));
    } else {
      emit(GenreError(
          listTvShowAndMovie: [],
          msg: result.error!.item1,
          filters: event.filters!));
    }
  }

  Future<void> _loadMoreGenres(
      LoadMoreGenreEvent event, Emitter<GenreState> emit) async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    var result =
        await _loadMoreTvShowAndMovieGenrePageUseCase(PaginationType.genrePage);
    if (result is DataSucess) {
      if (result.data!.isEmpty) {
        isLoadingMore = false;
        isFinalList = true;
        return;
      }
      emit(GenreDone(
          listTvShowAndMovie: [...state.listTvShowAndMovie, ...result.data!],
          msg: '',
          filters: state.filters));
    } else {
      emit(GenreError(
          listTvShowAndMovie: [],
          msg: result.error!.item1,
          filters: state.filters));
    }
    isLoadingMore = false;
  }
}
