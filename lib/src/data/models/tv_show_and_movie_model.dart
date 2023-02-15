// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:tem_final/src/data/models/imdb_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_info_status_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_rating_model.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_rating_entity.dart';

class TvShowAndMovieModel {
  final String id;
  final String title;
  final List<String> caseSearch;
  final String synopsis;
  final ImdbModel imdbInfo;
  final List<String> genres;
  final int runtime;
  final String ageClassification;
  final String posterImage;
  final String link;

  final bool isNewSeasonUpcoming;
  final int seasons;
  final int viewsCount;

  final List<TvShowAndMovieInfoStatusModel>
      listTvShowAndMovieInfoStatusBySeason;
  final List<TvShowAndMovieRatingModel> ratingList;
  final double averageRating;

  TvShowAndMovieModel({
    required this.id,
    required this.title,
    required this.caseSearch,
    required this.synopsis,
    required this.imdbInfo,
    required this.genres,
    required this.runtime,
    required this.ageClassification,
    required this.posterImage,
    required this.link,
    required this.isNewSeasonUpcoming,
    required this.seasons,
    required this.viewsCount,
    required this.listTvShowAndMovieInfoStatusBySeason,
    required this.ratingList,
    required this.averageRating,
  });

  TvShowAndMovieModel copyWith({
    String? id,
    String? title,
    List<String>? caseSearch,
    String? synopsis,
    ImdbModel? imdbInfo,
    List<String>? genres,
    int? runtime,
    String? ageClassification,
    String? posterImage,
    String? link,
    bool? isNewSeasonUpcoming,
    int? seasons,
    int? viewsCount,
    List<TvShowAndMovieInfoStatusModel>? listTvShowAndMovieInfoStatusBySeason,
    List<TvShowAndMovieRatingModel>? ratingList,
    double? averageRating,
  }) {
    return TvShowAndMovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      caseSearch: caseSearch ?? this.caseSearch,
      synopsis: synopsis ?? this.synopsis,
      imdbInfo: imdbInfo ?? this.imdbInfo,
      genres: genres ?? this.genres,
      runtime: runtime ?? this.runtime,
      ageClassification: ageClassification ?? this.ageClassification,
      posterImage: posterImage ?? this.posterImage,
      link: link ?? this.link,
      isNewSeasonUpcoming: isNewSeasonUpcoming ?? this.isNewSeasonUpcoming,
      seasons: seasons ?? this.seasons,
      viewsCount: viewsCount ?? this.viewsCount,
      listTvShowAndMovieInfoStatusBySeason:
          listTvShowAndMovieInfoStatusBySeason ??
              this.listTvShowAndMovieInfoStatusBySeason,
      ratingList: ratingList ?? this.ratingList,
      averageRating: averageRating ?? this.averageRating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'caseSearch': caseSearch,
      'synopsis': synopsis,
      'imdbInfo': imdbInfo.toMap(),
      'genres': genres,
      'runtime': runtime,
      'ageClassification': ageClassification,
      'posterImage': posterImage,
      'link': link,
      'isNewSeasonUpcoming': isNewSeasonUpcoming,
      'seasons': seasons,
      'viewsCount': viewsCount,
      'listTvShowAndMovieInfoStatusBySeason':
          listTvShowAndMovieInfoStatusBySeason.map((x) => x.toMap()).toList(),
      'ratingList': ratingList,
      'averageRating': averageRating,
    };
  }

  factory TvShowAndMovieModel.fromMap(Map<String, dynamic> map) {
    var ratingList = List<TvShowAndMovieRatingModel>.from((map['ratingList'])
        .map<TvShowAndMovieRatingModel>((x) =>
            TvShowAndMovieRatingModel.fromMap(x as Map<String, dynamic>)));
    return TvShowAndMovieModel(
      id: map['id'].toString(),
      title: map['title'] as String,
      caseSearch: List<String>.from(map['caseSearch']),
      synopsis: map['synopsis'] as String,
      imdbInfo: ImdbModel.fromMap(map['imdbInfo'] as Map<String, dynamic>),
      genres: List<String>.from(map['genres']),
      runtime: map['runtime'] as int,
      ageClassification: map['ageClassification'] as String,
      posterImage: map['posterImage'] as String,
      link: map['link'] as String,
      isNewSeasonUpcoming: map['isNewSeasonUpcoming'] as bool,
      seasons: map['seasons'] as int,
      viewsCount: map['viewsCount'] as int,
      listTvShowAndMovieInfoStatusBySeason:
          List<TvShowAndMovieInfoStatusModel>.from(
        (map['listTvShowAndMovieInfoStatusBySeason'])
            .map<TvShowAndMovieInfoStatusModel>(
          (x) =>
              TvShowAndMovieInfoStatusModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      ratingList: ratingList,
      averageRating: map['averageRating'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TvShowAndMovieModel.fromJson(String source) =>
      TvShowAndMovieModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TvShowAndMovieModel(id: $id, title: $title, caseSearch: $caseSearch, synopsis: $synopsis, imdbInfo: $imdbInfo, genres: $genres, runtime: $runtime, ageClassification: $ageClassification, posterImage: $posterImage, link: $link, isNewSeasonUpcoming: $isNewSeasonUpcoming, seasons: $seasons, viewsCount: $viewsCount, listTvShowAndMovieInfoStatusBySeason: $listTvShowAndMovieInfoStatusBySeason, ratingList: $ratingList, averageRating: $averageRating)';
  }

  @override
  bool operator ==(covariant TvShowAndMovieModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        listEquals(other.caseSearch, caseSearch) &&
        other.synopsis == synopsis &&
        other.imdbInfo == imdbInfo &&
        listEquals(other.genres, genres) &&
        other.runtime == runtime &&
        other.ageClassification == ageClassification &&
        other.posterImage == posterImage &&
        other.link == link &&
        other.isNewSeasonUpcoming == isNewSeasonUpcoming &&
        other.seasons == seasons &&
        other.viewsCount == viewsCount &&
        listEquals(other.listTvShowAndMovieInfoStatusBySeason,
            listTvShowAndMovieInfoStatusBySeason) &&
        listEquals(other.ratingList, ratingList) &&
        other.averageRating == averageRating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        caseSearch.hashCode ^
        synopsis.hashCode ^
        imdbInfo.hashCode ^
        genres.hashCode ^
        runtime.hashCode ^
        ageClassification.hashCode ^
        posterImage.hashCode ^
        link.hashCode ^
        isNewSeasonUpcoming.hashCode ^
        seasons.hashCode ^
        viewsCount.hashCode ^
        listTvShowAndMovieInfoStatusBySeason.hashCode ^
        ratingList.hashCode ^
        averageRating.hashCode;
  }
}
