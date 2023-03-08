// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:tem_final/src/core/utils/constants.dart';

import 'package:tem_final/src/domain/entities/imdb_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_rating_entity.dart';

class TvShowAndMovie extends Equatable {
  final String id;
  final String title;
  final String synopsis;
  final Imdb imdbInfo;
  final List<String> genres;
  final int runtime;
  final String ageClassification;
  final String posterImage;
  final bool isNewSeasonUpcoming;
  final int seasons;
  final int viewsCount;
  final List<TvShowAndMovieInfoStatus> listTvShowAndMovieInfoStatusBySeason;
  final ConclusionType actualStatus;
  final bool isFavorite;
  final int countConclusion;
  int localRating;
  ConclusionType? localConclusion;

  final List<TvShowAndMovieRating> ratingList;

  final double averageRating;
  TvShowAndMovie({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.imdbInfo,
    required this.genres,
    required this.runtime,
    required this.ageClassification,
    required this.posterImage,
    required this.isNewSeasonUpcoming,
    required this.seasons,
    required this.viewsCount,
    required this.listTvShowAndMovieInfoStatusBySeason,
    required this.isFavorite,
    required this.actualStatus,
    required this.countConclusion,
    this.localRating = -1,
    this.localConclusion,
    required this.ratingList,
    required this.averageRating,
  });

  @override
  List<Object> get props {
    return [
      id,
    ];
  }
}
