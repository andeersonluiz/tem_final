// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

class FavoriteEvent extends Equatable {
  final TvShowAndMovie? tvShowAndMovie;
  final String? idTvShowAndMovie;

  const FavoriteEvent({
    this.tvShowAndMovie,
    this.idTvShowAndMovie,
  });

  @override
  List<Object> get props => [tvShowAndMovie ?? "", idTvShowAndMovie ?? ""];
}

class SetFavoriteEvent extends FavoriteEvent {
  const SetFavoriteEvent({required super.tvShowAndMovie});
}

class UpdateFavoriteEvent extends FavoriteEvent {}

class GetFavoriteEvent extends FavoriteEvent {
  const GetFavoriteEvent({super.idTvShowAndMovie});
}

class ResetFavoriteEvent extends FavoriteEvent {
  const ResetFavoriteEvent();
}
