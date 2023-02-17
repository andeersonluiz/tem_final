import 'package:bloc/src/transition.dart';
import 'package:bloc/src/change.dart';
import 'package:bloc/src/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:tem_final/src/core/bloc/bloc_with_state.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_main_page_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_rating_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_state.dart';
import 'package:tuple/tuple.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc(
    this._updateRatingUseCase,
  ) : super(RatingLoading()) {
    on<UpdateRatingEvent>(_ratingTvShowAndMovie);
    on<SaveRatingEvent>(_saveRatingTvShowAndMovie);
  }
  final UpdateRatingUseCase _updateRatingUseCase;
  bool isLoading = false;

  int ratingValue = 1;
  Future<void> _ratingTvShowAndMovie(
      UpdateRatingEvent event, Emitter<RatingState> emit) async {
    print("entri2");
    emit(RatingLoading());
    ratingValue = event.ratingValue;
    emit(RatingDone(ratingValue));
  }

  Future<void> _saveRatingTvShowAndMovie(
      SaveRatingEvent event, Emitter<RatingState> emit) async {
    print("entri");
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
