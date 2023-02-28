import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';
import 'package:tuple/tuple.dart';

import '../../core/resources/data_state.dart';
import '../../core/utils/constants.dart';

class FilterGenresUseCase
    implements
        UseCase<DataState<List<TvShowAndMovie>>, Tuple2<Filter, FilterGenre>> {
  FilterGenresUseCase(this._tvShowAndMovieRepository);

  final TvShowAndMovieRepository _tvShowAndMovieRepository;
  @override
  Future<DataState<List<TvShowAndMovie>>> call(
      Tuple2<Filter, FilterGenre> params) {
    return _tvShowAndMovieRepository.filterGenres(params);
  }
}
