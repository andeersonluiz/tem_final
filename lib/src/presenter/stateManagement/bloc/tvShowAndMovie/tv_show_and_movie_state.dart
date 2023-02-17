// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tuple/tuple.dart';

import 'package:tem_final/src/core/bloc/bloc_with_state.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

abstract class TvShowAndMovieState extends Equatable {
  const TvShowAndMovieState({
    required this.filterSelected,
    this.data,
    this.error,
  });
  final List<Tuple2<String, List<TvShowAndMovie>>>? data;
  final String? error;
  final String filterSelected;
  @override
  List<Object> get props => [data ?? [], error ?? ""];
}

//class TvShowAndMovieInitial extends TvShowAndMovieState {}

class TvShowAndMovieLoading extends TvShowAndMovieState {
  TvShowAndMovieLoading(Filter filterSelected)
      : super(filterSelected: filterSelected.string);
}

class TvShowAndMovieDone extends TvShowAndMovieState {
  TvShowAndMovieDone(
      List<Tuple2<String, List<TvShowAndMovie>>> data, Filter filterSelected)
      : super(data: data, filterSelected: filterSelected.string);
}

class TvShowAndMovieError extends TvShowAndMovieState {
  TvShowAndMovieError(String error, Filter filterSelected)
      : super(error: error, filterSelected: filterSelected.string);
}
