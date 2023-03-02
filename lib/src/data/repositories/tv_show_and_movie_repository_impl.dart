import 'package:either_dart/either.dart';
import 'package:tem_final/src/core/resources/device_info.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/data/datasource/local/local_preferences_handler_service.dart';
import 'package:tem_final/src/data/datasource/remote/firebase_handler_service.dart';
import 'package:tem_final/src/data/mappers/tv_show_and_movie_mapper.dart';
import 'package:tem_final/src/data/mappers/user_history_mapper.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_rating_model.dart';
import 'package:tem_final/src/data/models/user_choice_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tem_final/src/data/models/user_rating_model.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

import 'package:tem_final/src/core/utils/constants.dart';

import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';
import 'package:tuple/tuple.dart';

import '../../domain/repositories/tv_show_and_movie_repository.dart';

class TvShowAndMovieRepositoryImpl implements TvShowAndMovieRepository {
  TvShowAndMovieRepositoryImpl(
      {required this.firebaseHandlerService,
      required this.localPreferencesHandlerService,
      required this.mapper,
      required this.userHistoryMapper,
      required this.userRepository});

  final FirebaseHandlerService firebaseHandlerService;
  final LocalPreferencesHandlerService localPreferencesHandlerService;
  final TvShowAndMovieMapper mapper;
  final UserHistoryMapper userHistoryMapper;
  final UserRepository userRepository;
  // ignore: slash_for_doc_comments
  /** 
   * remote_datasource
  */

  Future<Either<bool, Tuple2<String, StackTrace>>> _updateUserHistoryRating(
    String idTvShowAndMovie,
    int ratingValue,
  ) async {
    String userId = localPreferencesHandlerService.getUserId();
    Either<UserHistoryModel?, Tuple2<String, StackTrace>> resultGetUserHistory =
        localPreferencesHandlerService.getUserHistory();
    if (resultGetUserHistory.isLeft) {
      UserHistoryModel? userHistoryModel = resultGetUserHistory.left;
      if (userHistoryModel != null) {
        var index = userHistoryModel.listUserRatings.indexWhere(
            (element) => idTvShowAndMovie == element.idTvShowAndMovie);
        UserRatingModel userRatingModel = UserRatingModel(
            idTvShowAndMovie: idTvShowAndMovie,
            ratingValue: ratingValue.toDouble());
        if (index != -1) {
          userHistoryModel.listUserRatings[index] = userRatingModel;
        } else {
          userHistoryModel.listUserRatings.add(userRatingModel);
        }
        var resultRating = await firebaseHandlerService.updateUserHistoryRating(
            userId, userHistoryModel);
        if (resultRating.isLeft) {
          var resultUpdateUserHistory = await localPreferencesHandlerService
              .updateUserHistory(userHistoryModel);

          if (resultUpdateUserHistory.isLeft) {
            return const Left(true);
          } else {
            return Right(resultUpdateUserHistory.right);
          }
        } else {
          return Right(resultRating.right);
        }
      } else {
        return Right(resultGetUserHistory.right);
      }
    } else {
      return Right(resultGetUserHistory.right);
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>> _updateTvShowAndMovieRating(
      TvShowAndMovie tvShowAndMovie, int ratingValue) async {
    String userId = localPreferencesHandlerService.getUserId();

    TvShowAndMovieModel tvShowAndMovieModel =
        mapper.entityToModel(tvShowAndMovie);
    late TvShowAndMovieRatingModel tvShowAndMovieRatingModel =
        TvShowAndMovieRatingModel(idUser: userId, rating: ratingValue);
    var result = await firebaseHandlerService.updateRatingInsideTvShowAndMovie(
        tvShowAndMovieModel.id, tvShowAndMovieRatingModel);
    if (result.isLeft) {
      return const Left(true);
    } else {
      return Right(result.right);
    }
  }

  @override
  Future<DataState<bool>> updateRating(
      Tuple2<TvShowAndMovie, int> params) async {
    TvShowAndMovie tvShowAndMovie = params.item1;
    int ratingValue = params.item2;
    if (await _checkUserIsLoggedOtherDevice()) {
      await userRepository.logOut();

      return DataFailed(
        const Tuple2(Strings.userLoggedOtherDevice, StackTrace.empty),
      );
    }
    /**atualizar o rating na parte do usuário */
    var resultUpdateUserHistory =
        await _updateUserHistoryRating(tvShowAndMovie.id, ratingValue);
    /**atualizar o rating na parte do tvshowandmovie */
    var resultTvShowAndMovie =
        await _updateTvShowAndMovieRating(tvShowAndMovie, ratingValue);
    if (resultUpdateUserHistory.isLeft && resultTvShowAndMovie.isLeft) {
      return const DataSucess(true);
    } else {
      String stackTraceUpdateUserHistory = resultUpdateUserHistory.isRight
          ? resultUpdateUserHistory.right.item2.toString()
          : "no has error";
      String stackTraceTvShowAndMovie = resultTvShowAndMovie.isRight
          ? resultTvShowAndMovie.right.item2.toString()
          : "no has error";

      return DataFailed(
        Tuple2(
            Strings.errorToUpdateRating,
            StackTrace.fromString(
                "UpdateUserHistory: $stackTraceUpdateUserHistory | TvShowAndMovie : $stackTraceTvShowAndMovie")),
      );
    }
  }

  @override
  Future<DataState<List<Tuple2<GenreType, List<TvShowAndMovie>>>>>
      getAllTvShowAndMovie() async {
    var firebaseResponse = await firebaseHandlerService.getAllTvShowAndMovie();

    if (firebaseResponse.isLeft) {
      var tuples = _convertTuple(firebaseResponse.left);

      return DataSucess(tuples);
    }
    return DataFailed(firebaseResponse.right);
  }

  @override
  Future<DataState<List<Tuple2<GenreType, List<TvShowAndMovie>>>>>
      getAllMovie() async {
    var firebaseResponse = await firebaseHandlerService.getAllMovie();

    if (firebaseResponse.isLeft) {
      return DataSucess(_convertTuple(firebaseResponse.left));
    }
    return DataFailed(firebaseResponse.right);
  }

  @override
  Future<DataState<List<Tuple2<GenreType, List<TvShowAndMovie>>>>>
      getAllTvShow() async {
    var firebaseResponse = await firebaseHandlerService.getAllTvShow();

    if (firebaseResponse.isLeft) {
      return DataSucess(_convertTuple(firebaseResponse.left));
    }
    return DataFailed(firebaseResponse.right);
  }

  @override
  Future<DataState<TvShowAndMovie?>> getTvShowAndMovie(String id) async {
    var firebaseResponse = await firebaseHandlerService.getTvShowAndMovie(id);
    String userId = localPreferencesHandlerService.getUserId();
    Either<UserHistoryModel?, Tuple2<String, StackTrace>> resultUserHistory =
        localPreferencesHandlerService.getUserHistory();

    if (firebaseResponse.isLeft) {
      if (firebaseResponse.left.isEmpty) return const DataSucess(null);
      //atuatiza rating
      TvShowAndMovie? tvShowAndMovie = mapper
          .modelToEntity(TvShowAndMovieModel.fromMap(firebaseResponse.left));
      var index = tvShowAndMovie.ratingList
          .indexWhere((element) => element.idUser == userId);

      if (index != -1) {
        tvShowAndMovie.localRating = tvShowAndMovie.ratingList[index].rating;
      }
      //atualiza conclusion
      if (resultUserHistory.isLeft && resultUserHistory.left != null) {
        var userHistory = resultUserHistory.left;
        var index = userHistory!.listUserChoices
            .indexWhere((e) => e.idTvShowAndMovie == id);
        if (index != -1) {
          tvShowAndMovie.localConclusion =
              userHistory.listUserChoices[index].conclusionSelected;
        }
      }

      return DataSucess(tvShowAndMovie);
    } else {
      return DataFailed(firebaseResponse.right);
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
      return DataFailed(firebaseResponse.right);
    }
  }

  @override
  Future<DataState<List<TvShowAndMovie>>>
      getRecentsTvShowAndMovieViewed() async {
    var resultRecentsViewed =
        localPreferencesHandlerService.getRecentsTvShowAndMovieViewed();

    if (resultRecentsViewed.isLeft) {
      return DataSucess(resultRecentsViewed.left
          .map((item) => mapper.modelToEntity(item))
          .toList());
    } else {
      return DataFailed(resultRecentsViewed.right);
    }
  }

  @override
  Future<DataState<bool>> setRecentsTvShowAndMovieViewed(
      TvShowAndMovie tvShowAndMovie) async {
    var resultRecentsViewed = await localPreferencesHandlerService
        .setRecentsTvShowAndMovieViewed(mapper.entityToModel(tvShowAndMovie));

    if (resultRecentsViewed.isLeft) {
      return const DataSucess(true);
    } else {
      return DataFailed(resultRecentsViewed.right);
    }
  }

  @override
  Future<DataState<String>> selectConclusion(
      Tuple2<TvShowAndMovie, ConclusionType> params) async {
    if (await _checkUserIsLoggedOtherDevice()) {
      await userRepository.logOut();
      return DataFailed(
        const Tuple2(Strings.userLoggedOtherDevice, StackTrace.empty),
      );
    }
    String idTvShowAndMovie = params.item1.id;
    int seasonSelected =
        params.item1.listTvShowAndMovieInfoStatusBySeason.length;
    ConclusionType conclusionType = params.item2;
    var userHistory = localPreferencesHandlerService.getUserHistory();
    if (userHistory.isLeft && userHistory.left != null) {
      var resUpdateConclusionUser = await _updateConclusionUser(
          idTvShowAndMovie, seasonSelected, conclusionType, userHistory.left!);
      if (resUpdateConclusionUser.item1 is ConclusionType?) {
        Either<String, Tuple2<String, StackTrace>> resultData =
            await firebaseHandlerService.selectConclusion(
                seasonSelected - 1, idTvShowAndMovie, conclusionType,
                conclusionToDecrease: resUpdateConclusionUser.item1);
        if (resultData.isLeft) {
          return DataSucess(resultData.left);
        } else {
          return DataFailed(resultData.right);
        }
      } else {
        return DataFailed(
          Tuple2(resUpdateConclusionUser.item1.toString(),
              resUpdateConclusionUser.item2),
        );
      }
    } else {
      return DataFailed(
        const Tuple2(Strings.defaultError, StackTrace.empty),
      );
    }
  }

  Future<Tuple2<dynamic, StackTrace>> _updateConclusionUser(
      String idTvShowAndMovie,
      int seasonSelected,
      ConclusionType conclusionType,
      UserHistoryModel userHistoryModel) async {
    int index = userHistoryModel.listUserChoices.indexWhere((element) =>
        element.seasonSelected == seasonSelected &&
        element.idTvShowAndMovie == idTvShowAndMovie);
    UserChoiceModel userChoiceModel = UserChoiceModel(
        idTvShowAndMovie: idTvShowAndMovie,
        seasonSelected: seasonSelected,
        conclusionSelected: conclusionType);
    ConclusionType? oldConclusionType;
    if (index == -1) {
      userHistoryModel.listUserChoices.add(userChoiceModel);
    } else {
      oldConclusionType =
          userHistoryModel.listUserChoices[index].conclusionSelected;
      userHistoryModel.listUserChoices[index] = userChoiceModel;
    }
    var resDatabase =
        await firebaseHandlerService.selectConclusionUser(userHistoryModel);
    var resLocal = await localPreferencesHandlerService
        .updateUserHistory(userHistoryModel);

    if (resLocal.isLeft && resDatabase.isLeft) {
      return Tuple2(oldConclusionType, StackTrace.empty);
    } else if (resLocal.isRight) {
      return resLocal.right;
    } else {
      return resDatabase.right;
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
      return DataFailed(resultPersistence.right);
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
      return DataFailed(resultPersistence.right);
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
            DataFailed(resultSetId.right);
          }
        } else {
          DataFailed(firebaseResponse.right);
        }
      }
    } else {
      DataFailed(resultData.right);
    }
  }

  //* TESTADO *//
  @override
  Future<DataState<List<TvShowAndMovie>>> loadMoreTvShowAndMovieGenrePage(
      PaginationType paginationType) async {
    var resultData = await firebaseHandlerService
        .loadMoreTvShowAndMoviesGenrePage(paginationType);
    if (resultData.isLeft) {
      List<TvShowAndMovie> listTvShowAndMovie = resultData.left
          .map(
              (item) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(item)))
          .toList();
      return DataSucess(listTvShowAndMovie);
    } else {
      return DataFailed(resultData.right);
    }
  }

  @override
  Future<DataState<List<Tuple2<GenreType, List<TvShowAndMovie>>>>>
      loadMoreTvShowAndMovieMainPage(Filter filterMainPage) async {
    var resultData = await firebaseHandlerService
        .loadMoreTvShowAndMoviesMainPage(filterMainPage);
    if (resultData.isLeft) {
      var tuples = _convertTuple(resultData.left);
      return DataSucess(tuples);
    } else {
      return DataFailed(resultData.right);
    }
  }

  @override
  Future<DataState<List<TvShowAndMovie>>> getTvShowAndMovieByGenres(
      List<GenreType> genres) async {
    var resultGenres =
        await firebaseHandlerService.getTvShowAndMovieByGenres(genres);
    if (resultGenres.isLeft) {
      List<TvShowAndMovie> listTvShowAndMovie = resultGenres.left
          .map((e) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(e)))
          .toList();
      return DataSucess(listTvShowAndMovie);
    } else {
      return DataFailed(resultGenres.right);
    }
  }

  List<Tuple2<GenreType, List<TvShowAndMovie>>> _convertTuple(
      List<Tuple2<GenreType, List<Map<String, dynamic>>>>
          listTvShowAndMovieJson) {
    List<Tuple2<GenreType, List<TvShowAndMovie>>> tupleList = [];
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
        tupleList.sort((a, b) => a.item1.string.compareTo(b.item1.string));
      }
      tupleList.sort((a, b) {
        int valueA = values[a.item1] ?? 0;
        int valueB = values[b.item1] ?? 0;
        return valueB.compareTo(valueA);
      });
    } else {
      tupleList.sort((a, b) => a.item1.string.compareTo(b.item1.string));
    }
    return tupleList;
  }

  @override
  Future<DataState<List<TvShowAndMovie>>> filterGenres(
      Tuple2<Filter, FilterGenre> params) async {
    var result = await firebaseHandlerService.filterGenres(params);
    if (result.isLeft) {
      return DataSucess(result.left
          .map((e) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(e)))
          .toList());
    } else {
      return DataFailed(result.right);
    }
  }

  Future<bool> _checkUserIsLoggedOtherDevice() async {
    String deviceId = await DeviceInfo.getId();
    var userHistory = localPreferencesHandlerService.getUserHistory();
    if (userHistory.isLeft) {
      var resultAuth = await firebaseHandlerService.checkDeviceIdFromUser(
          userHistory.left!, deviceId);
      if (resultAuth.isLeft && !resultAuth.left) {
        return true;
      }
    }
    return false;
  }
}
