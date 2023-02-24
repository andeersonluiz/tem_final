import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tuple/tuple.dart';

abstract class TvShowAndMovieRepository {
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      getAllTvShowAndMovie();
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>> getAllTvShow();
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>> getAllMovie();
  Future<DataState<List<TvShowAndMovie>>> getTvShowAndMovieByGenres(
      List<GenreType> genres);

  Future<DataState<List<TvShowAndMovie>>> searchTvShowAndMovie(String query);

  Future<DataState<List<TvShowAndMovie>>> loadMoreTvShowAndMovie(
      PaginationType paginationType);
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      loadMoreTvShowAndMovieMainPage(Filter filterMainPage);
  Future<DataState<TvShowAndMovie?>> getTvShowAndMovie(String id);

  Future<DataState<String>> setTvSerieAndMoveWithFavorite(
    TvShowAndMovie tvShowAndMovie,
  );
  Future<DataState<List<TvShowAndMovie>>> getAllTvShowAndMovieWithFavorite();

  Future<DataState<String>> selectConclusion(
      Tuple2<TvShowAndMovie, ConclusionType> params);

  Future<void> updateTvShowAndMovieViewViewCount(String idTvShowAndMovie);
  Future<DataState<bool>> updateRating(Tuple2<TvShowAndMovie, int> params);

  Future<DataState<List<TvShowAndMovie>>> getRecentsTvShowAndMovieViewed();
  Future<DataState<bool>> setRecentsTvShowAndMovieViewed(
      TvShowAndMovie tvShowAndMovie);
}
