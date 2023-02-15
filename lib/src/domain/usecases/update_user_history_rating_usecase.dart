import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/no_param_usecase.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';

class UpdateUserHistoryRatingUseCase
    implements UseCase<DataState<bool>, UserHistory> {
  UpdateUserHistoryRatingUseCase(this._tvShowandMovieRepository);
  final TvShowAndMovieRepository _tvShowandMovieRepository;
  @override
  Future<DataState<bool>> call(UserHistory userHistory) async {
    return await _tvShowandMovieRepository.updateUserHistoryRating(userHistory);
  }
}
