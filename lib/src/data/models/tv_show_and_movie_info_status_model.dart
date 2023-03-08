// ignore_for_file: public_member_api_docs
// ignore_for_file: sort_constructors_first

import 'dart:convert';

// ignore: depend_on_referenced_packages

class TvShowAndMovieInfoStatusModel {
  final int seasonNumber;
  final int hasFinalAndOpened;
  final int hasFinalAndClosed;
  final int noHasfinalAndNewSeason;
  final int noHasfinalAndNoNewSeason;
  final String posterImageUrl;
  final double widthPosterImage;
  final double heightPosterImage;
  const TvShowAndMovieInfoStatusModel({
    required this.seasonNumber,
    required this.hasFinalAndOpened,
    required this.hasFinalAndClosed,
    required this.noHasfinalAndNewSeason,
    required this.noHasfinalAndNoNewSeason,
    required this.posterImageUrl,
    required this.widthPosterImage,
    required this.heightPosterImage,
  });

  TvShowAndMovieInfoStatusModel copyWith({
    int? seasonNumber,
    int? hasFinalAndOpened,
    int? hasFinalAndClosed,
    int? noHasfinalAndNewSeason,
    int? noHasfinalAndNoNewSeason,
    String? posterImageUrl,
    double? widthPosterImage,
    double? heightPosterImage,
  }) {
    return TvShowAndMovieInfoStatusModel(
      seasonNumber: seasonNumber ?? this.seasonNumber,
      hasFinalAndOpened: hasFinalAndOpened ?? this.hasFinalAndOpened,
      hasFinalAndClosed: hasFinalAndClosed ?? this.hasFinalAndClosed,
      noHasfinalAndNewSeason:
          noHasfinalAndNewSeason ?? this.noHasfinalAndNewSeason,
      noHasfinalAndNoNewSeason:
          noHasfinalAndNoNewSeason ?? this.noHasfinalAndNoNewSeason,
      posterImageUrl: posterImageUrl ?? this.posterImageUrl,
      heightPosterImage: heightPosterImage ?? this.heightPosterImage,
      widthPosterImage: widthPosterImage ?? this.widthPosterImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'seasonNumber': seasonNumber,
      'hasFinalAndOpened': hasFinalAndOpened,
      'hasFinalAndClosed': hasFinalAndClosed,
      'noHasfinalAndNewSeason': noHasfinalAndNewSeason,
      'noHasfinalAndNoNewSeason': noHasfinalAndNoNewSeason,
      'posterImageUrl': posterImageUrl,
    };
  }

  factory TvShowAndMovieInfoStatusModel.fromMap(Map<String, dynamic> map) {
    return TvShowAndMovieInfoStatusModel(
        seasonNumber: map['seasonNumber'] as int,
        hasFinalAndOpened: map['hasFinalAndOpened'] as int,
        hasFinalAndClosed: map['hasFinalAndClosed'] as int,
        noHasfinalAndNewSeason: map['noHasfinalAndNewSeason'] as int,
        noHasfinalAndNoNewSeason: map['noHasfinalAndNoNewSeason'] as int,
        posterImageUrl: map['posterImageUrl'] as String,
        heightPosterImage: 0,
        widthPosterImage: 0);
  }

  String toJson() => json.encode(toMap());

  factory TvShowAndMovieInfoStatusModel.fromJson(String source) =>
      TvShowAndMovieInfoStatusModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TvShowAndMovieInfoStatusModel(seasonNumber: $seasonNumber, hasFinalAndOpened: $hasFinalAndOpened, hasFinalAndClosed: $hasFinalAndClosed, noHasfinalAndNewSeason: $noHasfinalAndNewSeason, noHasfinalAndNoNewSeason: $noHasfinalAndNoNewSeason, posterImageUrl: $posterImageUrl)';
  }

  @override
  bool operator ==(covariant TvShowAndMovieInfoStatusModel other) {
    if (identical(this, other)) return true;

    return other.seasonNumber == seasonNumber &&
        other.hasFinalAndOpened == hasFinalAndOpened &&
        other.hasFinalAndClosed == hasFinalAndClosed &&
        other.noHasfinalAndNewSeason == noHasfinalAndNewSeason &&
        other.noHasfinalAndNoNewSeason == noHasfinalAndNoNewSeason &&
        other.posterImageUrl == posterImageUrl;
  }

  @override
  int get hashCode {
    return seasonNumber.hashCode ^
        hasFinalAndOpened.hashCode ^
        hasFinalAndClosed.hashCode ^
        noHasfinalAndNewSeason.hashCode ^
        noHasfinalAndNoNewSeason.hashCode ^
        posterImageUrl.hashCode;
  }
}
