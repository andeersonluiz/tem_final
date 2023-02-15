import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';

class MockLoadMoreTvShowAndMovieUseCase
    implements UseCase<DataState<List<TvShowAndMovie>>, PaginationType> {
  MockLoadMoreTvShowAndMovieUseCase(this._tvShowAndMovieRepository);

  final TvShowAndMovieRepository _tvShowAndMovieRepository;

  @override
  Future<DataState<List<TvShowAndMovie>>> call(PaginationType params) {
    return _tvShowAndMovieRepository.loadMoreTvShowAndMovie(params);
  }
}
