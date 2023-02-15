import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tem_final/src/core/resources/cryto_tools.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_model.dart';
import 'package:tem_final/src/data/models/user_choice_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tem_final/src/domain/entities/user_choice_entity.dart';
import 'package:tuple/tuple.dart';

import '../../../core/utils/strings.dart';

class LocalPreferencesHandlerService {
  static late SharedPreferences _instance;
  static late CryptoTools _cryptoTools;
  init() async {
    _instance = await SharedPreferences.getInstance();
    _cryptoTools = CryptoTools();
  }

  //* TESTADO *//
  Future<Either<String, Tuple2<String, StackTrace>>>
      setTvSerieAndMoveWithFavorite(
    TvShowAndMovieModel tvShowAndMovieModel,
  ) async {
    try {
      //throw Exception("teste");
      String? jsonStringOld =
          _instance.getString(kFavoritesTvShowAndMoviesKeyEncrypted);
      List<TvShowAndMovieModel> localListTvSerieAndMoviesModel = [];
      bool addFavorite = true;
      if (jsonStringOld == null) {
        localListTvSerieAndMoviesModel.add(tvShowAndMovieModel);
      } else {
        List<dynamic> tvShowAndMovieJson =
            jsonDecode(_cryptoTools.decrypt(jsonStringOld));
        localListTvSerieAndMoviesModel = tvShowAndMovieJson
            .map((e) => TvShowAndMovieModel.fromJson(e))
            .toList();

        if (localListTvSerieAndMoviesModel.contains(tvShowAndMovieModel)) {
          addFavorite = false;
          localListTvSerieAndMoviesModel
              .removeWhere((item) => item.id == tvShowAndMovieModel.id);
        } else {
          localListTvSerieAndMoviesModel.add(tvShowAndMovieModel);
        }
      }

      String jsonStringNew =
          _cryptoTools.encrypt(jsonEncode(localListTvSerieAndMoviesModel));

      await _instance.setString(
          kFavoritesTvShowAndMoviesKeyEncrypted, jsonStringNew);
      return Left(
          "${tvShowAndMovieModel.seasons == 0 ? "Filme" : "Série"}${addFavorite ? Strings.msgSucessAddFavorite : ""}");
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorSetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Either<List<TvShowAndMovieModel>, Tuple2<String, StackTrace>>
      getAllTvSerieAndMoveWithFavorite() {
    try {
      //throw Exception("teste");
      String? jsonString =
          _instance.getString(kFavoritesTvShowAndMoviesKeyEncrypted);

      List<TvShowAndMovieModel> localListTvSerieAndMoviesModel = [];

      if (jsonString != null) {
        List<dynamic> tvShowAndMovieJson =
            jsonDecode(_cryptoTools.decrypt(jsonString));
        localListTvSerieAndMoviesModel = tvShowAndMovieJson
            .map((e) => TvShowAndMovieModel.fromJson(e))
            .toList();
      }

      return Left(localListTvSerieAndMoviesModel);
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorSetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Future<Either<String, Tuple2<String, StackTrace>>> loadUserId() async {
    String? userIdValue = _instance.getString(kUserIdKeyEncrypted);
    if (userIdValue == null) {
      return const Left("");
    } else {
      return Left(_cryptoTools.decrypt(userIdValue));
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>> setUserId(
      String userId) async {
    try {
      var result = await _instance.setString(
          kUserIdKeyEncrypted, _cryptoTools.encrypt(userId));
      return Left(result);
    } catch (e, stacktrace) {
      return Right(Tuple2(
          Strings.defaultError, StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Future<Either<void, Tuple2<String, StackTrace>>>
      setIdsTvShowsAndMoviesViewedFromDevice(String id) async {
    try {
      //throw Exception("abc");
      String? jsonStringOld = _instance.getString(
        kViwedTvShowAndMoviesUserIdKeyEncrypted,
      );
      List<String> listIdTvShowAndMoviesJsonModel = [];
      if (jsonStringOld == null) {
        listIdTvShowAndMoviesJsonModel.add(id);
      } else {
        listIdTvShowAndMoviesJsonModel =
            jsonDecode(_cryptoTools.decrypt(jsonStringOld));
        listIdTvShowAndMoviesJsonModel.add(id);
      }
      String jsonStringNew =
          _cryptoTools.encrypt(jsonEncode(listIdTvShowAndMoviesJsonModel));
      await _instance.setString(
          kViwedTvShowAndMoviesUserIdKeyEncrypted, jsonStringNew);
      return const Left(null);
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorSetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Either<List<String>, Tuple2<String, StackTrace>>
      getIdsTvShowsAndMoviesViewedFromDevice() {
    try {
      //throw Exception("abc");
      String? jsonString =
          _instance.getString(kViwedTvShowAndMoviesUserIdKeyEncrypted);
      List<String> listIdTvShowAndMoviesJsonModel = [];
      if (jsonString != null) {
        List<dynamic> tvShowAndMoviesJson =
            jsonDecode(_cryptoTools.decrypt(jsonString));
        listIdTvShowAndMoviesJsonModel =
            tvShowAndMoviesJson.map((e) => e.toString()).toList();
      }
      return Left(listIdTvShowAndMoviesJsonModel);
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorGetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>> updateUserHistory(
      UserHistoryModel userHistoryModel) async {
    try {
      //throw Exception("abc");
      await _instance.setString(kUserHistoryKeyEncrypted,
          _cryptoTools.encrypt(jsonEncode(userHistoryModel)));
      return const Left(true);
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorGetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<bool> clearUserHistory() async {
    return await _instance.remove(kUserHistoryKeyEncrypted);
  }

  clearUserId() async {
    return await _instance.remove(kUserIdKeyEncrypted);
  }

  Future<void> checkFavoriteTvShowAndMovieIntegrity() async {
    String? jsonFavoriteTvShowAndMovie =
        _instance.getString(kFavoritesTvShowAndMoviesKeyEncrypted);

    if (jsonFavoriteTvShowAndMovie != null) {
      var result = _tryDecode(_cryptoTools.decrypt(jsonFavoriteTvShowAndMovie));
      if (!result) {
        await _instance.remove(kFavoritesTvShowAndMoviesKeyEncrypted);
      }
    }
  }

  Future<bool> checkUserHistoryIntegrity() async {
    String? jsonUserHistory = _instance.getString(kUserHistoryKeyEncrypted);
    print(jsonUserHistory.toString());
    if (jsonUserHistory != null) {
      var result = _tryDecode(_cryptoTools.decrypt(jsonUserHistory));
      if (!result) {
        await _instance.remove(kUserHistoryKeyEncrypted);
        return false;
      }
    }
    return true;
  }

  //talvez no futuro tenha que mudar a logica, pois caso o usuario mudar a configuração do shared prefs, o sistema de visualização vai se resetado.
  Future<void> checkUserViewedTvShowAndMovieIntegrity() async {
    String? jsonViwedTvShowAndMovie =
        _instance.getString(kViwedTvShowAndMoviesUserIdKeyEncrypted);

    if (jsonViwedTvShowAndMovie != null) {
      var result = _tryDecode(_cryptoTools.decrypt(jsonViwedTvShowAndMovie));
      if (!result) {
        await _instance.remove(kViwedTvShowAndMoviesUserIdKeyEncrypted);
      }
    }
  }

  Future<void> checkGenreViewFromuserIntegrity() async {
    String? jsonUserGenreViwed = _instance.getString(kUserGenreEncypted);

    if (jsonUserGenreViwed != null) {
      var result = _tryDecode(_cryptoTools.decrypt(jsonUserGenreViwed));
      if (!result) {
        await _instance.remove(kUserGenreEncypted);
      }
    }
  }

  Either<UserHistoryModel?, Tuple2<String, StackTrace>> getUserHistory() {
    try {
      //throw Exception("abc");
      String? jsonString = _instance.getString(kUserHistoryKeyEncrypted);
      UserHistoryModel? userHistoryModel;
      if (jsonString == null) {
      } else {
        print("GET");
        userHistoryModel = UserHistoryModel.fromJson(
            jsonDecode(_cryptoTools.decrypt(jsonString)));
        print(userHistoryModel.listUserRatings);
      }
      return Left(userHistoryModel);
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorGetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TEM QUE TESTAR *//
  Future<Either<bool, Tuple2<String, StackTrace>>> addGenresViewedFromUser(
      List<GenreType> genres) async {
    try {
      //throw Exception("abc");
      String? jsonString = _instance.getString(kUserGenreEncypted);
      Map<String, int> mapGenres = {};
      if (jsonString == null) {
        for (GenreType genre in genres) {
          mapGenres[genre.string] = 1;
        }
      } else {
        mapGenres = jsonDecode(_cryptoTools.decrypt(jsonString));
        for (GenreType genre in genres) {
          if (mapGenres.containsKey(genre.string)) {
            mapGenres[genre.string] = mapGenres[genre.string]! + 1;
          } else {
            mapGenres[genre.string] = 1;
          }
        }
      }
      await _instance.setString(
          kUserGenreEncypted, _cryptoTools.encrypt(jsonEncode(mapGenres)));

      return const Left(true);
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorGetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Either<Map<String, int>, Tuple2<String, StackTrace>>
      getGenresViewedFromUser() {
    try {
      //throw Exception("abc");
      String? jsonString = _instance.getString(kUserGenreEncypted);
      Map<String, int> mapGenres = {};
      if (jsonString != null) {
        mapGenres = jsonDecode(_cryptoTools.decrypt(jsonString));
      }

      return Left(mapGenres);
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorGetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  bool _tryDecode(String data) {
    print(data);
    try {
      jsonDecode(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
