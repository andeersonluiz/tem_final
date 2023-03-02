// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';

abstract class TvShowAndMovieInfoState extends Equatable {
  final TvShowAndMovie? tvShowAndMovie;
  final String? error;
  final TvShowAndMovieInfoStatus? tvShowAndMovieInfoStatus;

  const TvShowAndMovieInfoState(
      {this.tvShowAndMovie, this.error, this.tvShowAndMovieInfoStatus});

  @override
  List<Object> get props =>
      [tvShowAndMovie ?? "", error ?? "", tvShowAndMovieInfoStatus ?? ""];
}

class TvShowAndMovieInfoLoading extends TvShowAndMovieInfoState {}

class TvShowAndMovieInfoDone extends TvShowAndMovieInfoState {
  const TvShowAndMovieInfoDone(TvShowAndMovie tvShowAndMovie,
      TvShowAndMovieInfoStatus tvShowAndMovieInfoStatus)
      : super(
            tvShowAndMovie: tvShowAndMovie,
            tvShowAndMovieInfoStatus: tvShowAndMovieInfoStatus);
}

class TvShowAndMovieInfoError extends TvShowAndMovieInfoState {
  const TvShowAndMovieInfoError(
    String error,
  ) : super(error: error);
}
