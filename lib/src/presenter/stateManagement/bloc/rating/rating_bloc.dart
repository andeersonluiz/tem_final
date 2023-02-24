import 'package:bloc/bloc.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/usecases/update_rating_usecase.dart';
import 'package:tem_final/src/domain/usecases/verifiy_user_is_logged_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_state.dart';
import 'package:tuple/tuple.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc(this._updateRatingUseCase, this._verifitUserIsLoggedUseCase)
      : super(RatingLoading()) {
    on<UpdateRatingEvent>(_ratingTvShowAndMovie);
    on<SaveRatingEvent>(_saveRatingTvShowAndMovie);
  }
  final UpdateRatingUseCase _updateRatingUseCase;
  final VerifitUserIsLoggedUseCase _verifitUserIsLoggedUseCase;

  bool isLoading = false;

  int ratingValue = 1;
  Future<void> _ratingTvShowAndMovie(
      UpdateRatingEvent event, Emitter<RatingState> emit) async {
    emit(RatingLoading());
    ratingValue = event.ratingValue;
    emit(RatingDone(ratingValue));
  }

  Future<void> _saveRatingTvShowAndMovie(
      SaveRatingEvent event, Emitter<RatingState> emit) async {
    if (!await _verifitUserIsLoggedUseCase()) {
      emit(const Unauthorized(Strings.unauthorizedUser));
    } else {
      emit(RatingLoading());
      isLoading = true;
      DataState<bool> result = await _updateRatingUseCase(
          Tuple2(event.tvShowAndMovie!, event.ratingValue));
      if (result is DataSucess) {
        emit(SavingRatingDone(event.ratingValue, Strings.ratingSuccessful));
      } else {
        emit(RatingError(result.error!.item1));
      }
      isLoading = false;
    }
  }
}
