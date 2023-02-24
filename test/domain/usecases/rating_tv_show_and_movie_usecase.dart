import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';

class MockRatingTvShowAndMovieUseCase
    implements UseCase<DataState<bool>, UserHistory> {
  MockRatingTvShowAndMovieUseCase(this._tvShowandMovieRepository);
  final TvShowAndMovieRepository _tvShowandMovieRepository;
  @override
  Future<DataState<bool>> call(UserHistory userHistory) async {
    return await _tvShowandMovieRepository.ratingTvShowAndMovie(userHistory);
  }
}
