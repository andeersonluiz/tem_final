// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';

abstract class TvShowAndMovieInfoEvent extends Equatable {
  const TvShowAndMovieInfoEvent({this.id, this.tvShowAndMovieInfoStatus});
  final String? id;
  final TvShowAndMovieInfoStatus? tvShowAndMovieInfoStatus;

  @override
  List<Object> get props => [id ?? "", tvShowAndMovieInfoStatus ?? ""];
}

class GetTvShowAndMovieEvent extends TvShowAndMovieInfoEvent {
  const GetTvShowAndMovieEvent({required super.id});
}

class UpdateTvShowAndMovieInfoStatus extends TvShowAndMovieInfoEvent {
  const UpdateTvShowAndMovieInfoStatus(
      {required super.tvShowAndMovieInfoStatus});
}
