import 'package:tem_final/src/core/resources/no_return_usecase.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';

class MockupdateTvShowAndMovieViewCountUseCase
    implements NoReturnUseCase<String> {
  MockupdateTvShowAndMovieViewCountUseCase(this._tvShowAndMovieRepository);

  final TvShowAndMovieRepository _tvShowAndMovieRepository;

  @override
  Future<void> call(String params) {
    return _tvShowAndMovieRepository.updateTvShowAndMovieViewViewCount(params);
  }
}
