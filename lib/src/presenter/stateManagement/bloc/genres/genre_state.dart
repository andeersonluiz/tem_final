// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

class GenreState extends Equatable {
  final List<TvShowAndMovie> listTvShowAndMovie;
  final String msg;
  final Tuple2<Filter, FilterGenre> filters;
  const GenreState({
    required this.listTvShowAndMovie,
    required this.msg,
    required this.filters,
  });

  @override
  List<Object> get props => [listTvShowAndMovie, msg];
}

class GenreLoading extends GenreState {
  const GenreLoading(
      {required super.listTvShowAndMovie,
      required super.msg,
      required super.filters});
}

class GenreDone extends GenreState {
  GenreDone(
      {required super.listTvShowAndMovie,
      required super.msg,
      required super.filters});
}

class GenreError extends GenreState {
  GenreError(
      {required super.listTvShowAndMovie,
      required super.msg,
      required super.filters});
}
