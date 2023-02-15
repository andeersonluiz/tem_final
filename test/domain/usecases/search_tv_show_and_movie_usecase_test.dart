import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';

class MockSearchTvShowAndMovieUseCase
    implements UseCase<DataState<List<TvShowAndMovie>>, String> {
  MockSearchTvShowAndMovieUseCase(this._tvShowAndMovieRepository);

  final TvShowAndMovieRepository _tvShowAndMovieRepository;

  @override
  Future<DataState<List<TvShowAndMovie>>> call(String params) {
    return _tvShowAndMovieRepository.searchTvShowAndMovie(params);
  }
}
