// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserRatingModel {
  final String idTvShowAndMovie;
  final double ratingValue;
  UserRatingModel({
    required this.idTvShowAndMovie,
    required this.ratingValue,
  });

  UserRatingModel copyWith({
    String? idTvShowAndMovie,
    double? ratingValue,
  }) {
    return UserRatingModel(
      idTvShowAndMovie: idTvShowAndMovie ?? this.idTvShowAndMovie,
      ratingValue: ratingValue ?? this.ratingValue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTvShowAndMovie': idTvShowAndMovie,
      'ratingValue': ratingValue,
    };
  }

  factory UserRatingModel.fromMap(Map<String, dynamic> map) {
    return UserRatingModel(
      idTvShowAndMovie: map['idTvShowAndMovie'] as String,
      ratingValue: map['ratingValue'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRatingModel.fromJson(String source) =>
      UserRatingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserRatingModel(idTvShowAndMovie: $idTvShowAndMovie, ratingValue: $ratingValue)';

  @override
  bool operator ==(covariant UserRatingModel other) {
    if (identical(this, other)) return true;

    return other.idTvShowAndMovie == idTvShowAndMovie &&
        other.ratingValue == ratingValue;
  }

  @override
  int get hashCode => idTvShowAndMovie.hashCode ^ ratingValue.hashCode;
}
