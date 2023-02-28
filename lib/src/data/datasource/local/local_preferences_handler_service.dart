import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tem_final/src/core/resources/cryto_tools.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
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
      if (addFavorite) {
        return Left(
            "${tvShowAndMovieModel.seasons == -1 ? "Filme" : "Série"}${addFavorite ? Strings.msgSucessAddFavorite : ""}");
      } else {
        return const Left("");
      }
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
      return Right(Tuple2(Strings.msgErrorGetLocalPreferences,
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

  Future<String> loadUsername() async {
    String? usernameValue = _instance.getString(kUserNameKeyEncrypted);
    if (usernameValue == null) {
      return "";
    } else {
      return _cryptoTools.decrypt(usernameValue);
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

  Future<Either<bool, Tuple2<String, StackTrace>>> setUsername(
      String userId) async {
    try {
      var result = await _instance.setString(
          kUserNameKeyEncrypted, _cryptoTools.encrypt(userId));
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
            List<String>.from(jsonDecode(_cryptoTools.decrypt(jsonStringOld)));
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

  clearUsername() async {
    return await _instance.remove(kUserNameKeyEncrypted);
  }

  getUserId() {
    String? stringUserId = _instance.getString(kUserIdKeyEncrypted);
    String userId = "";
    if (stringUserId != null) {
      userId = _cryptoTools.decrypt(stringUserId);
    }
    return userId;
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
        userHistoryModel = UserHistoryModel.fromJson(
            jsonDecode(_cryptoTools.decrypt(jsonString)));
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

  Either<List<TvShowAndMovieModel>, Tuple2<String, StackTrace>>
      getRecentsTvShowAndMovieViewed() {
    try {
      String? jsonString =
          _instance.getString(kRecentsTvShowAndMovieViwedKeyEncrypted);
      List<TvShowAndMovieModel> listTvShowAndMovieModel = [];
      // _instance.remove(kRecentsTvShowAndMovieViwedKeyEncrypted);
      if (jsonString == null) {
        return Left(listTvShowAndMovieModel);
      } else {
        listTvShowAndMovieModel = jsonDecode(_cryptoTools.decrypt(jsonString))
            .map<TvShowAndMovieModel>(
                (item) => TvShowAndMovieModel.fromJson(item))
            .toList();
        return Left(listTvShowAndMovieModel);
      }
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorGetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>>
      setRecentsTvShowAndMovieViewed(
          TvShowAndMovieModel tvShowAndMovieModel) async {
    try {
      String? jsonString =
          _instance.getString(kRecentsTvShowAndMovieViwedKeyEncrypted);

      if (jsonString == null) {
        await _instance.setString(kRecentsTvShowAndMovieViwedKeyEncrypted,
            _cryptoTools.encrypt(jsonEncode([tvShowAndMovieModel])));
      } else {
        List<TvShowAndMovieModel> listTvShowAndMovieModel =
            jsonDecode(_cryptoTools.decrypt(jsonString))
                .map<TvShowAndMovieModel>(
                    (item) => TvShowAndMovieModel.fromJson(item))
                .toList();
        var index = listTvShowAndMovieModel
            .indexWhere((element) => element.id == tvShowAndMovieModel.id);
        if (index != -1) {
          var item = listTvShowAndMovieModel.removeAt(index);
          listTvShowAndMovieModel.insert(listTvShowAndMovieModel.length, item);
        } else {
          if (listTvShowAndMovieModel.length >= 5) {
            listTvShowAndMovieModel.removeAt(0);
          }
          listTvShowAndMovieModel.add(tvShowAndMovieModel);
        }

        await _instance.setString(kRecentsTvShowAndMovieViwedKeyEncrypted,
            _cryptoTools.encrypt(jsonEncode(listTvShowAndMovieModel)));
      }
      return const Left(true);
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorGetLocalPreferences,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  bool _tryDecode(String data) {
    try {
      jsonDecode(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
