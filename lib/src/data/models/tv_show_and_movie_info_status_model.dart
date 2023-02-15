// ignore_for_file: public_member_api_docs
// ignore_for_file: sort_constructors_first

import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class TvShowAndMovieInfoStatusModel {
  final int seasonNumber;
  final int conclusiveCount;
  final int openEndedCount;
  final int unknownCount;
  final String posterImageUrl;

  const TvShowAndMovieInfoStatusModel({
    required this.seasonNumber,
    required this.conclusiveCount,
    required this.openEndedCount,
    required this.unknownCount,
    required this.posterImageUrl,
  });

  TvShowAndMovieInfoStatusModel copyWith({
    int? seasonNumber,
    int? conclusiveCount,
    int? openEndedCount,
    int? unknownCount,
    String? posterImageUrl,
  }) {
    return TvShowAndMovieInfoStatusModel(
      seasonNumber: seasonNumber ?? this.seasonNumber,
      conclusiveCount: conclusiveCount ?? this.conclusiveCount,
      openEndedCount: openEndedCount ?? this.openEndedCount,
      unknownCount: unknownCount ?? this.unknownCount,
      posterImageUrl: posterImageUrl ?? this.posterImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'seasonNumber': seasonNumber,
      'conclusiveCount': conclusiveCount,
      'openEndedCount': openEndedCount,
      'unknownCount': unknownCount,
      'posterImageUrl': posterImageUrl,
    };
  }

  factory TvShowAndMovieInfoStatusModel.fromMap(Map<String, dynamic> map) {
    return TvShowAndMovieInfoStatusModel(
      seasonNumber: map['seasonNumber'] as int,
      conclusiveCount: map['conclusiveCount'] as int,
      openEndedCount: map['openEndedCount'] as int,
      unknownCount: map['unknownCount'] as int,
      posterImageUrl: map['posterImageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TvShowAndMovieInfoStatusModel.fromJson(String source) =>
      TvShowAndMovieInfoStatusModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TvShowAndMovieInfoStatusModel(seasonNumber: $seasonNumber, conclusiveCount: $conclusiveCount, openEndedCount: $openEndedCount, unknownCount: $unknownCount, posterImageUrl: $posterImageUrl)';
  }

  @override
  bool operator ==(covariant TvShowAndMovieInfoStatusModel other) {
    if (identical(this, other)) return true;

    return other.seasonNumber == seasonNumber &&
        other.conclusiveCount == conclusiveCount &&
        other.openEndedCount == openEndedCount &&
        other.unknownCount == unknownCount &&
        other.posterImageUrl == posterImageUrl;
  }

  @override
  int get hashCode {
    return seasonNumber.hashCode ^
        conclusiveCount.hashCode ^
        openEndedCount.hashCode ^
        unknownCount.hashCode ^
        posterImageUrl.hashCode;
  }
}
