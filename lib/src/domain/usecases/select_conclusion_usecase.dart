import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';
import 'package:tuple/tuple.dart';

class SelectConclusionUseCase
    implements
        UseCase<DataState<String>, Tuple2<TvShowAndMovie, ConclusionType>> {
  SelectConclusionUseCase(this._tvShowAndMovieRepository);

  final TvShowAndMovieRepository _tvShowAndMovieRepository;

  @override
  Future<DataState<String>> call(
      Tuple2<TvShowAndMovie, ConclusionType> params) {
    return _tvShowAndMovieRepository.selectConclusion(params);
  }
}
