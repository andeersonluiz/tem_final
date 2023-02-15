import 'package:tem_final/src/core/resources/mapper.dart';
import 'package:tem_final/src/data/models/imdb_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_info_status_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_rating_model.dart';
import 'package:tem_final/src/domain/entities/imdb_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_rating_entity.dart';

class TvShowAndMovieMapper
    implements Mapper<TvShowAndMovie, TvShowAndMovieModel> {
  @override
  TvShowAndMovie modelToEntity(model,
      {bool isFavorite = false, bool isRated = false}) {
    List<TvShowAndMovieInfoStatusModel> tvShowAndMovieInfoStatusModel =
        model.listTvShowAndMovieInfoStatusBySeason;
    return TvShowAndMovie(
      id: model.id,
      title: model.title,
      synopsis: model.synopsis,
      imdbInfo: Imdb(
          rating: model.imdbInfo.rating, lastUpdate: model.imdbInfo.lastUpdate),
      genres: model.genres,
      runtime: model.runtime,
      ageClassification: model.ageClassification,
      posterImage: model.posterImage,
      link: model.link,
      isNewSeasonUpcoming: model.isNewSeasonUpcoming,
      seasons: model.seasons,
      viewsCount: model.viewsCount,
      averageRating: model.averageRating,
      ratingList: model.ratingList
          .map((m) => TvShowAndMovieRating(idUser: m.idUser, rating: m.rating))
          .toList(),
      isRated: isRated,
      listTvShowAndMovieInfoStatusBySeason: tvShowAndMovieInfoStatusModel
          .map((item) => TvShowAndMovieInfoStatus(
              conclusiveCount: item.conclusiveCount,
              openEndedCount: item.openEndedCount,
              seasonNumber: item.seasonNumber,
              unknownCount: item.unknownCount,
              posterImageUrl: item.posterImageUrl))
          .toList(),
      isFavorite: isFavorite,
    );
  }

  @override
  TvShowAndMovieModel entityToModel(entity) {
    List<TvShowAndMovieInfoStatus> tvShowAndMovieInfoStatus =
        entity.listTvShowAndMovieInfoStatusBySeason;
    return TvShowAndMovieModel(
        id: entity.id,
        title: entity.title,
        caseSearch: [],
        synopsis: entity.synopsis,
        imdbInfo: ImdbModel(
            rating: entity.imdbInfo.rating,
            lastUpdate: entity.imdbInfo.lastUpdate),
        genres: entity.genres,
        runtime: entity.runtime,
        ageClassification: entity.ageClassification,
        posterImage: entity.posterImage,
        link: entity.link,
        isNewSeasonUpcoming: entity.isNewSeasonUpcoming,
        seasons: entity.seasons,
        viewsCount: entity.viewsCount,
        averageRating: entity.averageRating,
        ratingList: entity.ratingList
            .map((e) =>
                TvShowAndMovieRatingModel(idUser: e.idUser, rating: e.rating))
            .toList(),
        listTvShowAndMovieInfoStatusBySeason: tvShowAndMovieInfoStatus
            .map((item) => TvShowAndMovieInfoStatusModel(
                conclusiveCount: item.conclusiveCount,
                openEndedCount: item.openEndedCount,
                seasonNumber: item.seasonNumber,
                unknownCount: item.unknownCount,
                posterImageUrl: item.posterImageUrl))
            .toList());
  }
}
