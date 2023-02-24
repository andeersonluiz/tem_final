import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';

import '../entities/tv_show_and_movie_entity.dart';

class SetRecentsTvShowAndMovieViewedUseCase
    implements UseCase<DataState<bool>, TvShowAndMovie> {
  SetRecentsTvShowAndMovieViewedUseCase(this._tvShowAndMovieRepository);
  final TvShowAndMovieRepository _tvShowAndMovieRepository;

  @override
  Future<DataState<bool>> call(TvShowAndMovie params) async {
    return await _tvShowAndMovieRepository
        .setRecentsTvShowAndMovieViewed(params);
  }
}
