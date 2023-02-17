// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tuple/tuple.dart';

import 'package:tem_final/src/core/bloc/bloc_with_state.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

abstract class RatingState extends Equatable {
  const RatingState({
    this.ratingValue,
    this.error,
    this.sucess,
  });
  final String? error;
  final String? sucess;
  final int? ratingValue;
  @override
  List<Object> get props => [ratingValue ?? "", error ?? "", sucess ?? ""];
}

class RatingLoading extends RatingState {}

class RatingDone extends RatingState {
  const RatingDone(int ratingValue) : super(ratingValue: ratingValue);
}

class SavingRatingDone extends RatingState {
  const SavingRatingDone(int ratingValue, String sucess)
      : super(ratingValue: ratingValue, sucess: sucess);
}

class RatingError extends RatingState {
  const RatingError(String error) : super(error: error);
}
