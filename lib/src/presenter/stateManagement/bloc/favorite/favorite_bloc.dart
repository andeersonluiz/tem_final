import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_move_with_favorite_usecase.dart';
import 'package:tem_final/src/domain/usecases/set_tv_serie_and_movie_with_favorite_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc(this._getAllTvShowAndMovieWithFavoriteUseCase,
      this._setTvSerieAndMovieWithFavoriteUseCase)
      : super(const FavoriteLoading(
            favoriteList: [], msg: '', isFavorite: false)) {
    on<SetFavoriteEvent>(_setFavorite);
    on<GetFavoriteEvent>(_getFavorite);
    on<UpdateFavoriteEvent>(_updateFavorite);

    on<ResetFavoriteEvent>(_resetFavorite);
  }

  final GetAllTvShowAndMovieWithFavoriteUseCase
      _getAllTvShowAndMovieWithFavoriteUseCase;
  final SetTvSerieAndMovieWithFavoriteUseCase
      _setTvSerieAndMovieWithFavoriteUseCase;
  Future<void> _setFavorite(
      SetFavoriteEvent event, Emitter<FavoriteState> emit) async {
    DataState result =
        await _setTvSerieAndMovieWithFavoriteUseCase(event.tvShowAndMovie!);
    if (result is DataSucess) {
      List<TvShowAndMovie> favoriteListUpdated = state.favoriteList.toList();
      bool isFavorite = false;
      var index = favoriteListUpdated
          .indexWhere((element) => element.id == event.tvShowAndMovie!.id);

      if (index != -1) {
        favoriteListUpdated.removeAt(index);
      } else {
        favoriteListUpdated.add(event.tvShowAndMovie!);
        isFavorite = true;
      }
      emit(FavoriteToastDone(
          favoriteList: favoriteListUpdated,
          msg: result.data,
          isFavorite: isFavorite));
    } else {
      emit(FavoriteError(
          favoriteList: state.favoriteList,
          msg: result.error!.item1,
          isFavorite: state.isFavorite));
    }
  }

  Future<void> _updateFavorite(
      UpdateFavoriteEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteDone(
        favoriteList: state.favoriteList,
        msg: "",
        isFavorite: state.isFavorite));
  }

  Future<void> _getFavorite(
      GetFavoriteEvent event, Emitter<FavoriteState> emit) async {
    DataState result = await _getAllTvShowAndMovieWithFavoriteUseCase();
    if (result is DataSucess) {
      if (event.idTvShowAndMovie == null) {
        emit(FavoriteDone(
            favoriteList: result.data.reversed.toList(),
            msg: "",
            isFavorite: false));
      } else {
        bool isFavorite = result.data!
            .where((item) => item.id == event.idTvShowAndMovie)
            .toList()
            .isNotEmpty;

        emit(FavoriteDone(
            favoriteList: result.data.reversed.toList(),
            msg: "",
            isFavorite: isFavorite));
      }
    } else {
      emit(FavoriteError(
          favoriteList: state.favoriteList,
          msg: result.error!.item1,
          isFavorite: state.isFavorite));
    }
  }

  _resetFavorite(ResetFavoriteEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading(
        favoriteList: state.favoriteList,
        msg: '',
        isFavorite: state.isFavorite));
  }
}
