import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/no_param_usecase.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';
import 'package:tuple/tuple.dart';

class MockGetAllMovieUseCase
    implements
        NoParamUseCase<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>> {
  MockGetAllMovieUseCase(this._tvShowAndMovieRepository);

  final TvShowAndMovieRepository _tvShowAndMovieRepository;
  @override
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>> call() {
    return _tvShowAndMovieRepository.getAllMovie();
  }
}
