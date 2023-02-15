// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TvShowAndMovieRatingModel {
  final String idUser;
  final int rating;
  TvShowAndMovieRatingModel({
    required this.idUser,
    required this.rating,
  });

  TvShowAndMovieRatingModel copyWith({
    String? idUser,
    int? rating,
  }) {
    return TvShowAndMovieRatingModel(
      idUser: idUser ?? this.idUser,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUser': idUser,
      'rating': rating,
    };
  }

  factory TvShowAndMovieRatingModel.fromMap(Map<String, dynamic> map) {
    return TvShowAndMovieRatingModel(
      idUser: map['idUser'].toString(),
      rating: map['rating'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TvShowAndMovieRatingModel.fromJson(String source) =>
      TvShowAndMovieRatingModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TvShowAndMovieRatingModel(idUser: $idUser, rating: $rating)';

  @override
  bool operator ==(covariant TvShowAndMovieRatingModel other) {
    if (identical(this, other)) return true;

    return other.idUser == idUser && other.rating == rating;
  }

  @override
  int get hashCode => idUser.hashCode ^ rating.hashCode;
}
