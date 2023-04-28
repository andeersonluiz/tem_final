// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tem_final/src/core/utils/constants.dart';

import 'package:tem_final/src/data/models/imdb_model.dart';
import 'package:tem_final/src/data/models/streaming_info_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_info_status_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_rating_model.dart';
import 'package:tuple/tuple.dart';

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
  final ConclusionType actualStatus;
  final bool isNewSeasonUpcoming;
  final int seasons;
  final int viewsCount;

  final List<TvShowAndMovieInfoStatusModel>
      listTvShowAndMovieInfoStatusBySeason;
  final int countConclusions;
  final List<TvShowAndMovieRatingModel> ratingList;
  final double averageRating;
  final List<StreamingInfoModel> streamingList;

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
    required this.isNewSeasonUpcoming,
    required this.seasons,
    required this.viewsCount,
    required this.actualStatus,
    required this.listTvShowAndMovieInfoStatusBySeason,
    required this.ratingList,
    required this.countConclusions,
    required this.averageRating,
    required this.streamingList,
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
    ConclusionType? actualStatus,
    int? seasons,
    int? viewsCount,
    List<TvShowAndMovieInfoStatusModel>? listTvShowAndMovieInfoStatusBySeason,
    List<TvShowAndMovieRatingModel>? ratingList,
    double? averageRating,
    int? countConclusions,
    List<StreamingInfoModel>? streamingList,
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
        isNewSeasonUpcoming: isNewSeasonUpcoming ?? this.isNewSeasonUpcoming,
        seasons: seasons ?? this.seasons,
        viewsCount: viewsCount ?? this.viewsCount,
        listTvShowAndMovieInfoStatusBySeason:
            listTvShowAndMovieInfoStatusBySeason ??
                this.listTvShowAndMovieInfoStatusBySeason,
        ratingList: ratingList ?? this.ratingList,
        averageRating: averageRating ?? this.averageRating,
        actualStatus: actualStatus ?? this.actualStatus,
        countConclusions: countConclusions ?? this.countConclusions,
        streamingList: streamingList ?? this.streamingList);
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
      'isNewSeasonUpcoming': isNewSeasonUpcoming,
      'seasons': seasons,
      'viewsCount': viewsCount,
      'listTvShowAndMovieInfoStatusBySeason':
          listTvShowAndMovieInfoStatusBySeason.map((x) => x.toMap()).toList(),
      'ratingList': ratingList.map((e) => e.toMap()).toList(),
      'countConclusions': countConclusions,
      'averageRating': averageRating,
      'streamingList': streamingList.map((e) => e.toMap()).toList()
    };
  }

  factory TvShowAndMovieModel.fromMap(Map<String, dynamic> map) {
    List<TvShowAndMovieRatingModel> ratingList =
        List<TvShowAndMovieRatingModel>.from(
            (map['ratingList']).map<TvShowAndMovieRatingModel>((x) {
      return TvShowAndMovieRatingModel.fromMap(x as Map<String, dynamic>);
    })).toList();
    var listTvShowAndMovieInfoStatusBySeason =
        List<TvShowAndMovieInfoStatusModel>.from(
      (map['listTvShowAndMovieInfoStatusBySeason'])
          .map<TvShowAndMovieInfoStatusModel>(
        (x) => TvShowAndMovieInfoStatusModel.fromMap(x as Map<String, dynamic>),
      ),
    );
    TvShowAndMovieInfoStatusModel tvShowAndMovieInfoStatusModelLast =
        listTvShowAndMovieInfoStatusBySeason.last;
    Tuple2<ConclusionType, int> tuple = Tuple2(ConclusionType.hasFinalAndClosed,
        tvShowAndMovieInfoStatusModelLast.hasFinalAndClosed);
    if (tuple.item2 < tvShowAndMovieInfoStatusModelLast.hasFinalAndOpened) {
      tuple = Tuple2(ConclusionType.hasFinalAndOpened,
          tvShowAndMovieInfoStatusModelLast.hasFinalAndOpened);
    }
    if (tuple.item2 <
        tvShowAndMovieInfoStatusModelLast.noHasfinalAndNewSeason) {
      tuple = Tuple2(ConclusionType.noHasfinalAndNewSeason,
          tvShowAndMovieInfoStatusModelLast.noHasfinalAndNewSeason);
    }
    if (tuple.item2 <
        tvShowAndMovieInfoStatusModelLast.noHasfinalAndNoNewSeason) {
      tuple = Tuple2(ConclusionType.noHasfinalAndNoNewSeason,
          tvShowAndMovieInfoStatusModelLast.noHasfinalAndNoNewSeason);
    }
    int countConclusions = tvShowAndMovieInfoStatusModelLast.hasFinalAndClosed +
        tvShowAndMovieInfoStatusModelLast.hasFinalAndOpened +
        tvShowAndMovieInfoStatusModelLast.noHasfinalAndNewSeason +
        tvShowAndMovieInfoStatusModelLast.noHasfinalAndNoNewSeason;
    var streamingInfo = map['streamingInfo'] ?? [];
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
      isNewSeasonUpcoming: map['isNewSeasonUpcoming'] as bool,
      seasons: map['seasons'] as int,
      viewsCount: map['viewsCount'] as int,
      listTvShowAndMovieInfoStatusBySeason:
          listTvShowAndMovieInfoStatusBySeason,
      ratingList: ratingList,
      averageRating: map['averageRating'].toDouble(),
      countConclusions: countConclusions,
      actualStatus: tuple.item1,
      streamingList: List<StreamingInfoModel>.from(streamingInfo
          .map<StreamingInfoModel>((item) => StreamingInfoModel.fromMap(item))
          .toList()),
    );
  }

  String toJson() => json.encode(toMap());

  factory TvShowAndMovieModel.fromJson(String source) =>
      TvShowAndMovieModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TvShowAndMovieModel(id: $id, title: $title, caseSearch: $caseSearch, synopsis: $synopsis, imdbInfo: $imdbInfo, genres: $genres, runtime: $runtime, ageClassification: $ageClassification, posterImage: $posterImage, actualStatus: $actualStatus, isNewSeasonUpcoming: $isNewSeasonUpcoming, seasons: $seasons, viewsCount: $viewsCount, countConclusions: $countConclusions, ratingList: $ratingList, averageRating: $averageRating, streamingList: $streamingList)';
  }

  @override
  bool operator ==(covariant TvShowAndMovieModel other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
