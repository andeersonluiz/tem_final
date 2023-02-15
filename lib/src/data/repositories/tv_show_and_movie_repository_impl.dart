import 'package:either_dart/either.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/data/datasource/auth/firebase_auth_handler_service.dart';
import 'package:tem_final/src/data/datasource/local/local_preferences_handler_service.dart';
import 'package:tem_final/src/data/datasource/remote/firebase_handler_service.dart';
import 'package:tem_final/src/data/mappers/tv_show_and_movie_mapper.dart';
import 'package:tem_final/src/data/mappers/user_history_mapper.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_rating_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

import 'package:tem_final/src/core/utils/constants.dart';

import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tuple/tuple.dart';

import '../../domain/repositories/tv_show_and_movie_repository.dart';

class TvShowAndMovieRepositoryImpl implements TvShowAndMovieRepository {
  TvShowAndMovieRepositoryImpl(
      {required this.firebaseHandlerService,
      required this.localPreferencesHandlerService,
      required this.mapper,
      required this.userHistoryMapper,
      required this.userId});

  final FirebaseHandlerService firebaseHandlerService;
  final LocalPreferencesHandlerService localPreferencesHandlerService;
  final TvShowAndMovieMapper mapper;
  final UserHistoryMapper userHistoryMapper;
  String userId;
  // ignore: slash_for_doc_comments
  /** 
   * remote_datasource
  */
  @override
  Future<DataState<bool>> updateUserHistoryRating(
      UserHistory userHistory) async {
    UserHistoryModel userHistoryModel =
        userHistoryMapper.entityToModel(userHistory);
    var resultRating = await firebaseHandlerService.updateUserHistoryRating(
        userId, userHistoryModel);
    if (resultRating.isLeft) {
      var resultUpdateUserHistory = await localPreferencesHandlerService
          .updateUserHistory(userHistoryModel);

      if (resultUpdateUserHistory.isLeft) {
        return const DataSucess(true);
      } else {
        return DataFailed(resultUpdateUserHistory.right, isLog: false);
      }
    } else {
      return DataFailed(resultRating.right, isLog: false);
    }
  }

  @override
  Future<DataState<bool>> updateTvShowAndMovieRating(
      Tuple2<TvShowAndMovie, int> params) async {
    TvShowAndMovieModel tvShowAndMovieModel =
        mapper.entityToModel(params.item1);
    List<TvShowAndMovieRatingModel> listTvShowAndMovieRatingModel =
        tvShowAndMovieModel.ratingList
            .where((element) => element.idUser == userId)
            .toList();
    late TvShowAndMovieRatingModel tvShowAndMovieRatingModel =
        TvShowAndMovieRatingModel(idUser: userId, rating: params.item2);

    var result = await firebaseHandlerService.updateRatingInsideTvShowAndMovie(
        tvShowAndMovieModel.id, tvShowAndMovieRatingModel);
    if (result.isLeft) {
      return DataSucess(true);
    } else {
      return DataFailed(result.right, isLog: false);
    }
  }

  @override
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      getAllTvShowAndMovie() async {
    var firebaseResponse = await firebaseHandlerService.getAllTvShowAndMovie();

    if (firebaseResponse.isLeft) {
      var tuples = _convertTuple(firebaseResponse.left);

      return DataSucess(tuples);
    }
    return DataFailed(firebaseResponse.right, isLog: false);
  }

  @override
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      getAllMovie() async {
    var firebaseResponse = await firebaseHandlerService.getAllMovie();

    if (firebaseResponse.isLeft) {
      return DataSucess(_convertTuple(firebaseResponse.left));
    }
    return DataFailed(firebaseResponse.right, isLog: false);
  }

  @override
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      getAllTvShow() async {
    var firebaseResponse = await firebaseHandlerService.getAllTvShow();

    if (firebaseResponse.isLeft) {
      return DataSucess(_convertTuple(firebaseResponse.left));
    }
    return DataFailed(firebaseResponse.right, isLog: false);
  }

  @override
  Future<DataState<TvShowAndMovie?>> getTvShowAndMovie(String id) async {
    var firebaseResponse = await firebaseHandlerService.getTvShowAndMovie(id);
    if (firebaseResponse.isLeft) {
      if (firebaseResponse.left.isEmpty) return const DataSucess(null);

      TvShowAndMovie? tvShowAndMovie = mapper
          .modelToEntity(TvShowAndMovieModel.fromMap(firebaseResponse.left));

      return DataSucess(tvShowAndMovie);
    } else {
      return DataFailed(firebaseResponse.right, isLog: false);
    }
  }

  @override
  Future<DataState<List<TvShowAndMovie>>> searchTvShowAndMovie(
      String query) async {
    var firebaseResponse =
        await firebaseHandlerService.searchTvShowAndMovie(query);
    if (firebaseResponse.isLeft) {
      var firebaseData = firebaseResponse.left;
      List<TvShowAndMovie> listTvShowAndMovie = firebaseData
          .map(
              (item) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(item)))
          .toList();

      return DataSucess(listTvShowAndMovie);
    } else {
      return DataFailed(firebaseResponse.right, isLog: false);
    }
  }

  @override
  Future<DataState<String>> selectConclusion(
      Tuple2<String, ConclusionType> params) async {
    Either<String, Tuple2<String, StackTrace>> resultData =
        await firebaseHandlerService.selectConclusion(
      0,
      params.item1,
      params.item2,
    );

    if (resultData.isLeft) {
      return DataSucess(resultData.left);
    } else {
      return DataFailed(resultData.right, isLog: false);
    }
  }

  // ignore: slash_for_doc_comments
  /** 
   * local_datasource
  */
  @override
  Future<DataState<String>> setTvSerieAndMoveWithFavorite(
      TvShowAndMovie tvShowAndMovie) async {
    TvShowAndMovieModel tvShowAndMovieModel =
        mapper.entityToModel(tvShowAndMovie);
    Either<String, Tuple2<String, StackTrace>> resultPersistence =
        await localPreferencesHandlerService
            .setTvSerieAndMoveWithFavorite(tvShowAndMovieModel);
    if (resultPersistence.isLeft) {
      return DataSucess(resultPersistence.left);
    } else {
      return DataFailed(resultPersistence.right, isLog: false);
    }
  }

  @override
  Future<DataState<List<TvShowAndMovie>>>
      getAllTvShowAndMovieWithFavorite() async {
    Either<List<TvShowAndMovieModel>, Tuple2<String, StackTrace>>
        resultPersistence =
        localPreferencesHandlerService.getAllTvSerieAndMoveWithFavorite();
    if (resultPersistence.isLeft) {
      List<TvShowAndMovie> listTvShowAndMovie = resultPersistence.left
          .map((item) => mapper.modelToEntity(
                item,
              ))
          .toList();
      return DataSucess(listTvShowAndMovie);
    } else {
      return DataFailed(resultPersistence.right, isLog: false);
    }
  }

  // ignore: slash_for_doc_comments
  /** 
   * remote_datasource and local_datasource
  */
  @override
  Future<void> updateTvShowAndMovieViewViewCount(
      String idTvShowAndMovie) async {
    Either<List<String>, Tuple2<String, StackTrace>> resultData =
        localPreferencesHandlerService.getIdsTvShowsAndMoviesViewedFromDevice();
    if (resultData.isLeft) {
      List<String> idsTvShowAndMovieViewed = resultData.left;
      if (!idsTvShowAndMovieViewed.contains(idTvShowAndMovie)) {
        Either<void, Tuple2<String, StackTrace>> firebaseResponse =
            await firebaseHandlerService
                .incrementTvShowAndMovieViewCount(idTvShowAndMovie);

        if (firebaseResponse.isLeft) {
          var resultSetId = await localPreferencesHandlerService
              .setIdsTvShowsAndMoviesViewedFromDevice(idTvShowAndMovie);
          if (resultSetId.isRight) {
            DataFailed(resultSetId.right, isLog: true);
          }
        } else {
          DataFailed(firebaseResponse.right, isLog: true);
        }
      }
    } else {
      DataFailed(resultData.right, isLog: true);
    }
  }

  //* TESTADO *//
  @override
  Future<DataState<List<TvShowAndMovie>>> loadMoreTvShowAndMovie(
      PaginationType paginationType) async {
    var resultData =
        await firebaseHandlerService.loadMoreTvShowAndMovies(paginationType);
    if (resultData.isLeft) {
      List<TvShowAndMovie> listTvShowAndMovie = resultData.left
          .map(
              (item) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(item)))
          .toList();
      return DataSucess(listTvShowAndMovie);
    } else {
      return DataFailed(resultData.right, isLog: false);
    }
  }

  @override
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      loadMoreTvShowAndMovieMainPage(
          PaginationTypeMainPage paginationTypeMainPage) async {
    var resultData = await firebaseHandlerService
        .loadMoreTvShowAndMoviesMainPage(paginationTypeMainPage);
    if (resultData.isLeft) {
      var tuples = _convertTuple(resultData.left);
      return DataSucess(tuples);
    } else {
      return DataFailed(resultData.right, isLog: false);
    }
  }

  @override
  Future<DataState<List<TvShowAndMovie>>> getTvShowAndMovieByGenres(
      List<GenreType> genres) async {
    var resultGenres =
        await firebaseHandlerService.getTvSeriesAndMovieByGenres(genres);
    if (resultGenres.isLeft) {
      List<TvShowAndMovie> listTvShowAndMovie = resultGenres.left
          .map((e) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(e)))
          .toList();
      return DataSucess(listTvShowAndMovie);
    } else {
      return DataFailed(resultGenres.right, isLog: false);
    }
  }

  List<Tuple2<String, List<TvShowAndMovie>>> _convertTuple(
      List<Tuple2<String, List<Map<String, dynamic>>>> listTvShowAndMovieJson) {
    List<Tuple2<String, List<TvShowAndMovie>>> tupleList = [];
    for (var tupleItem in listTvShowAndMovieJson) {
      for (Map<String, dynamic> tvShowAndMovieMap in tupleItem.item2) {
        TvShowAndMovie tvShowAndMovie = mapper
            .modelToEntity(TvShowAndMovieModel.fromMap(tvShowAndMovieMap));
        var index =
            tupleList.indexWhere((element) => element.item1 == tupleItem.item1);
        if (index != -1) {
          tupleList[index] = Tuple2(tupleList[index].item1,
              tupleList[index].item2 + [tvShowAndMovie]);
        } else {
          tupleList.add(Tuple2(tupleItem.item1, [tvShowAndMovie]));
        }
      }
    }

    tupleList = tupleList.where((element) => element.item2.length > 5).toList();
    Either<Map<String, int>, Tuple2<String, StackTrace>> resultGetGenres =
        localPreferencesHandlerService.getGenresViewedFromUser();
    if (resultGetGenres.isLeft) {
      Map<String, int> values = resultGetGenres.left;
      if (values.isEmpty) {
        tupleList.sort((a, b) => a.item1.compareTo(b.item1));
      }
      tupleList.sort((a, b) {
        int valueA = values[a.item1] ?? 0;
        int valueB = values[b.item1] ?? 0;
        return valueB.compareTo(valueA);
      });
    } else {
      tupleList.sort((a, b) => a.item1.compareTo(b.item1));
    }
    return tupleList;
  }
}
