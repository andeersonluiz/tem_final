// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:equatable/equatable.dart';

import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent({required this.ratingValue, this.tvShowAndMovie});
  final int ratingValue;
  final TvShowAndMovie? tvShowAndMovie;
  @override
  List<Object> get props => [ratingValue];
}

class UpdateRatingEvent extends RatingEvent {
  const UpdateRatingEvent(int rating) : super(ratingValue: rating);
}

class SaveRatingEvent extends RatingEvent {
  const SaveRatingEvent(int rating, TvShowAndMovie tvShowAndMovie)
      : super(ratingValue: rating, tvShowAndMovie: tvShowAndMovie);
}
