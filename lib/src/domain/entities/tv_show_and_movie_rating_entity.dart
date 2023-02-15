import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TvShowAndMovieRating extends Equatable {
  final String idUser;
  final int rating;
  const TvShowAndMovieRating({
    required this.idUser,
    required this.rating,
  });

  @override
  List<Object> get props => [idUser, rating];
}
