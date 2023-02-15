import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';

class MockSetTvSerieAndMovieWithFavoriteUseCase
    implements UseCase<DataState<String>, TvShowAndMovie> {
  MockSetTvSerieAndMovieWithFavoriteUseCase(this._tvShowAndMovieRepository);

  final TvShowAndMovieRepository _tvShowAndMovieRepository;
  @override
  Future<DataState<String>> call(TvShowAndMovie params) {
    return _tvShowAndMovieRepository.setTvSerieAndMoveWithFavorite(params);
  }
}
