import 'package:bloc/bloc.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_state.dart';

class TvShowAndMovieInfoBloc
    extends Bloc<TvShowAndMovieInfoEvent, TvShowAndMovieInfoState> {
  TvShowAndMovieInfoBloc(this._getTvShowAndMovieUseCase)
      : super(TvShowAndMovieInfoLoading()) {
    on<GetTvShowAndMovieEvent>(_getTvShowAndMovieInfo);
    on<UpdateTvShowAndMovieInfoStatus>(_updateTvShowAndMovieInfo);
  }
  final GetTvShowAndMovieUseCase _getTvShowAndMovieUseCase;
  late TvShowAndMovie tvShowAndMovie;

  Future<void> _getTvShowAndMovieInfo(GetTvShowAndMovieEvent event,
      Emitter<TvShowAndMovieInfoState> emit) async {
    emit(TvShowAndMovieInfoLoading());

    var resultGetTvShowAndMovie = await _getTvShowAndMovieUseCase(event.id!);
    if (resultGetTvShowAndMovie is DataSucess) {
      tvShowAndMovie = resultGetTvShowAndMovie.data!;
      emit(TvShowAndMovieInfoDone(tvShowAndMovie,
          tvShowAndMovie.listTvShowAndMovieInfoStatusBySeason.last));
    } else {
      emit(TvShowAndMovieInfoError(resultGetTvShowAndMovie.error!.item1));
    }
  }

  Future<void> _updateTvShowAndMovieInfo(UpdateTvShowAndMovieInfoStatus event,
      Emitter<TvShowAndMovieInfoState> emit) async {
    emit(TvShowAndMovieInfoDone(
        state.tvShowAndMovie!, event.tvShowAndMovieInfoStatus!));
  }
}
