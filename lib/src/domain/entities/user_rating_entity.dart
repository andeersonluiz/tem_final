// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class UserRating extends Equatable {
  final String idTvShowAndMovie;
  final double ratingValue;
  const UserRating({
    required this.idTvShowAndMovie,
    required this.ratingValue,
  });

  @override
  List<Object> get props => [idTvShowAndMovie, ratingValue];
}
