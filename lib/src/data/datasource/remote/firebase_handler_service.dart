import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tem_final/src/core/resources/connection_verifyer.dart';
import 'package:tem_final/src/core/resources/no_connection_exception.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_rating_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tuple/tuple.dart';
import '../../../core/utils/strings.dart';

class FirebaseHandlerService {
  FirebaseHandlerService() {
    _instance = Supabase.instance.client;
  }
  late SupabaseClient _instance;
  late bool _isFinalList;
  late bool _isFinalListGenrePage;
  late String _querySearch;
  late List<String> _listGenres;
  late int _offSet = 0;
  late int _offSetGenrePage = 0;

  late int _paginationNumber = 1;
  late int _paginationNumberGenrePage = 1;
  late Tuple2<Filter, FilterGenre> filterParams;
  late RealtimeChannel myChannel;

//* TESTADO *//
  Future<
      Either<List<Tuple2<GenreType, List<Map<String, dynamic>>>>,
          Tuple2<String, StackTrace>>> getAllTvShowAndMovie() async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _offSet = 0;
      _paginationNumber = 1;
      _isFinalList = false;
      List<Tuple2<GenreType, List<Map<String, dynamic>>>> tuples = [];

      for (GenreType genre in kGenresList.sublist(
          _offSet,
          kGenresList.length > pageSizeMainPage
              ? pageSizeMainPage
              : kGenresList.length)) {
        var queryDocumentData = await _instance
            .from(kDocumentTvShowAndMovies)
            .select()
            .contains("genres", [genre.string])
            .limit(kMaxTvShowAndMoviesByGenre)
            .order("popularity");
        List<Map<String, dynamic>> map = queryDocumentData
            .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
            .toList();
        tuples.add(Tuple2(genre, map));
      }
      if (tuples.length == pageSizeMainPage) {
        _offSet += pageSizeMainPage;
      } else {
        _isFinalList = true;
      }
      _paginationNumber += 1;
      return Left(tuples);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<
      Either<List<Tuple2<GenreType, List<Map<String, dynamic>>>>,
          Tuple2<String, StackTrace>>> getAllMovie() async {
    try {
      await ConnectionVerifyer.verify();

      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _offSet = 0;
      _paginationNumber = 1;
      _isFinalList = false;
      //TEM QUE SORTEAR
      List<Tuple2<GenreType, List<Map<String, dynamic>>>> tuples = [];

      for (GenreType genre in kGenresList.sublist(
          _offSet,
          kGenresList.length > pageSizeMainPage
              ? pageSizeMainPage
              : kGenresList.length)) {
        var queryDocumentData = await _instance
            .from(kDocumentTvShowAndMovies)
            .select()
            .contains("genres", [genre.string])
            .eq("seasons", -1)
            .order("popularity")
            .limit(kMaxTvShowAndMoviesByGenre);

        List<Map<String, dynamic>> map = queryDocumentData
            .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
            .toList();
        tuples.add(Tuple2(genre, map));
      }
      if (tuples.length == pageSizeMainPage) {
        _offSet += pageSizeMainPage;
      } else {
        _isFinalList = true;
      }
      _paginationNumber += 1;
      return Left(tuples);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<
      Either<List<Tuple2<GenreType, List<Map<String, dynamic>>>>,
          Tuple2<String, StackTrace>>> getAllTvShow() async {
    try {
      await ConnectionVerifyer.verify();

      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _offSet = 0;
      _paginationNumber = 1;
      _isFinalList = false;
      //TEM QUE SORTEAR
      List<Tuple2<GenreType, List<Map<String, dynamic>>>> tuples = [];

      for (GenreType genre in kGenresList.sublist(
          _offSet,
          kGenresList.length > pageSizeMainPage
              ? pageSizeMainPage
              : kGenresList.length)) {
        var queryDocumentData = await _instance
            .from(kDocumentTvShowAndMovies)
            .select()
            .contains("genres", [genre.string])
            .neq("seasons", -1)
            .limit(kMaxTvShowAndMoviesByGenre)
            .order("popularity");

        List<Map<String, dynamic>> map = queryDocumentData
            .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
            .toList();
        tuples.add(Tuple2(genre, map));
      }
      if (tuples.length == pageSizeMainPage) {
        _offSet += pageSizeMainPage;
      } else {
        _isFinalList = true;
      }
      _paginationNumber += 1;

      return Left(tuples);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Future<Either<Map<String, dynamic>, Tuple2<String, StackTrace>>>
      getTvShowAndMovie(String id) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      var queryDocumentData = await _instance
          .from(kDocumentTvShowAndMovies)
          .select()
          .eq("id", id)
          .limit(1);

      if (queryDocumentData.isEmpty) {
        return const Left({});
      }
      List<Map<String, dynamic>> map = queryDocumentData
          .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
          .toList();
      return Left(map.first);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Future<Either<List<Map<String, dynamic>>, Tuple2<String, StackTrace>>>
      searchTvShowAndMovie(String query) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      /* _offSet = 0;
      _paginationNumber = 1;
      _isFinalList = false;*/
      _querySearch = query.trim().toLowerCase();
      //TEM QUE ORDENAR
      var queryDocumentData = await _instance
          .from(kDocumentTvShowAndMovies)
          .select()
          .contains("caseSearch", [_querySearch])
          .order("popularity")
          .limit(pageSize);

      /* if (queryDocumentData.isNotEmpty) {
        if (queryDocumentData.length == pageSize) {
          _offSet += pageSize;
        } else {
          _offSet += queryDocumentData.length as int;
          _isFinalList = true;
        }
        _paginationNumber += 1;
      }
      if (queryDocumentData.isEmpty) {
        _isFinalList = true;
      }*/
      List<Map<String, dynamic>> map = queryDocumentData
          .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
          .toList();
      return Left(map);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Future<Either<String, Tuple2<String, StackTrace>>> selectConclusion(
      int seasonId, String id, ConclusionType conclusionType,
      {ConclusionType? conclusionToDecrease}) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");

      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      if (conclusionToDecrease != null) {
        switch (conclusionType) {
          case ConclusionType.hasFinalAndOpened:
            await _instance.rpc('increment_info_season_and_decrease', params: {
              'p_index': seasonId,
              'p_field': 'hasFinalAndOpened',
              'p_id': id,
              'p_field_decrease': conclusionToDecrease.string
            });
            break;
          case ConclusionType.hasFinalAndClosed:
            await _instance.rpc('increment_info_season_and_decrease', params: {
              'p_index': seasonId,
              'p_field': 'hasFinalAndClosed',
              'p_id': id,
              'p_field_decrease': conclusionToDecrease.string
            });
            break;
          case ConclusionType.noHasfinalAndNewSeason:
            await _instance.rpc('increment_info_season_and_decrease', params: {
              'p_index': seasonId,
              'p_field': 'noHasfinalAndNewSeason',
              'p_id': id,
              'p_field_decrease': conclusionToDecrease.string
            });
            break;
          case ConclusionType.noHasfinalAndNoNewSeason:
            await _instance.rpc('increment_info_season_and_decrease', params: {
              'p_index': seasonId,
              'p_field': 'noHasfinalAndNoNewSeason',
              'p_id': id,
              'p_field_decrease': conclusionToDecrease.string
            });
            break;
        }
      } else {
        switch (conclusionType) {
          case ConclusionType.hasFinalAndOpened:
            await _instance.rpc('increment_info_season', params: {
              'p_index': seasonId,
              'p_field': 'hasFinalAndOpened',
              'p_id': id
            });
            break;
          case ConclusionType.hasFinalAndClosed:
            await _instance.rpc('increment_info_season', params: {
              'p_index': seasonId,
              'p_field': 'hasFinalAndClosed',
              'p_id': id,
            });
            break;
          case ConclusionType.noHasfinalAndNewSeason:
            await _instance.rpc('increment_info_season', params: {
              'p_index': seasonId,
              'p_field': 'noHasfinalAndNewSeason',
              'p_id': id
            });
            break;
          case ConclusionType.noHasfinalAndNoNewSeason:
            await _instance.rpc('increment_info_season', params: {
              'p_index': seasonId,
              'p_field': 'noHasfinalAndNoNewSeason',
              'p_id': id
            });
            break;
        }
      }

      return const Left(Strings.msgSucessSelectConclusion);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<String, Tuple2<String, StackTrace>>> selectConclusionUser(
      UserHistoryModel userHistoryModel) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");

      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      await _instance
          .from(kDocumentUserHistory)
          .update(userHistoryModel.toMap())
          .eq("idUser", userHistoryModel.idUser);

      return const Left(Strings.msgSucessSelectConclusion);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Future<Either<void, Tuple2<String, StackTrace>>>
      incrementTvShowAndMovieViewCount(String idTvShowAndMovieModel) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("abc");
      await _instance
          .rpc('increment_view_count', params: {'p_id': idTvShowAndMovieModel});
      return const Left(null);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Future<Either<String, Tuple2<String, StackTrace>>> submitReport(
      String message, ReportType reportType, String idTvShowAndMovie) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');      bool hasErrorFindId = false;
      bool hasErrorFindId = false;
      if (idTvShowAndMovie.isNotEmpty) {
        var result = await _instance
            .from(kDocumentTvShowAndMovies)
            .select()
            .eq("id", idTvShowAndMovie);
        if (result.isEmpty) {
          hasErrorFindId = true;
        }
      }

      await _instance.from("reports").insert({
        "message": message,
        "reportType": reportType.string,
        "idTvShowAndMovie": idTvShowAndMovie.isEmpty ? "" : idTvShowAndMovie,
        "hasErrorId": hasErrorFindId
      });

      return const Left("");
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //*TESTADO*//
  Future<Either<List<Map<String, dynamic>>, Tuple2<String, StackTrace>>>
      loadMoreTvShowAndMoviesGenrePage(PaginationType paginationType) async {
    if (_isFinalListGenrePage) return const Left([]);
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      var moreData = await getQueryByPagination(paginationType);
      if (moreData.isNotEmpty) {
        if (moreData.length == pageSize) {
          _offSetGenrePage += pageSize;
        } else {
          _offSetGenrePage += moreData.length as int;
          _isFinalListGenrePage = true;
        }
        _paginationNumberGenrePage += 1;
      }
      if (moreData.isEmpty) {
        _isFinalListGenrePage = true;
      }
      List<Map<String, dynamic>> map = moreData
          .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
          .toList();
      return Left(map);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<
      Either<List<Tuple2<GenreType, List<Map<String, dynamic>>>>,
          Tuple2<String, StackTrace>>> loadMoreTvShowAndMoviesMainPage(
      Filter filterMainPage) async {
    if (_isFinalList) return const Left([]);
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      var moreData = (await getQueryByPaginationMainPage(filterMainPage));
      if (moreData.length == pageSizeMainPage) {
        _offSet += pageSizeMainPage;
      } else {
        _isFinalList = true;
      }
      _paginationNumber += 1;

      return Left(moreData);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //*TESTADO*//
  Future<Either<List<Map<String, dynamic>>, Tuple2<String, StackTrace>>>
      getTvShowAndMovieByGenres(List<GenreType> genres) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _listGenres = genres.map((e) => e.string).toList();
      _offSetGenrePage = 0;
      _isFinalListGenrePage = false;
      _paginationNumberGenrePage = 1;
      var data = await _instance
          .from(kDocumentTvShowAndMovies)
          .select()
          .contains("genres", _listGenres)
          .order("popularity")
          .range(_offSetGenrePage,
              ((pageSize * _paginationNumberGenrePage) - 1)); //0 15
      if (data.isNotEmpty) {
        if (data.length == pageSize) {
          _offSetGenrePage += pageSize;
        } else {
          _offSetGenrePage += data.length as int;
          _isFinalListGenrePage = true;
        }
        _paginationNumberGenrePage += 1;
      }
      if (data.isEmpty) {
        _isFinalListGenrePage = true;
      }

      List<Map<String, dynamic>> map = data
          .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
          .toList();

      return Left(map);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<UserHistoryModel?, Tuple2<String, StackTrace>>> getUserHistory(
      String userId) async {
    try {
      UserHistoryModel? userHistoryModel;
      var data = await _instance
          .from(kDocumentUserHistory)
          .select()
          .eq("idUser", userId);

      if (data.isEmpty) {
        userHistoryModel = null;
      } else {
        List<Map<String, dynamic>> map = data
            .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
            .toList();
        userHistoryModel = UserHistoryModel.fromMap(map.first);
      }
      return Left(userHistoryModel);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>> setUserHistory(
      UserHistoryModel userHistoryModel) async {
    try {
      await _instance
          .from(kDocumentUserHistory)
          .upsert(userHistoryModel.toMap());

      return const Left(true);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>> updateUserHistoryRating(
    String idUser,
    UserHistoryModel userHistoryModel,
  ) async {
    try {
      await ConnectionVerifyer.verify();
      var data = await _instance
          .from(kDocumentUserHistory)
          .select()
          .eq("idUser", idUser);

      if (data.isEmpty) {
        return const Right(
            Tuple2(Strings.userNotFoundFirebase, StackTrace.empty));
      } else {
        await _instance
            .from(kDocumentUserHistory)
            .upsert(userHistoryModel.toMap())
            .eq("idUser", idUser);
      }
      return const Left(true);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>>
      updateRatingInsideTvShowAndMovie(String idTvShowAndMovie,
          TvShowAndMovieRatingModel tvShowAndMovieRating) async {
    try {
      await ConnectionVerifyer.verify();

      await _instance.rpc('update_rating_list', params: {
        'p_id': idTvShowAndMovie,
        'value': tvShowAndMovieRating.toMap()
      });
      return const Left(true);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<List<Map<String, dynamic>>, Tuple2<String, StackTrace>>>
      filterGenres(Tuple2<Filter, FilterGenre> params) async {
    try {
      await ConnectionVerifyer.verify();
      //throw NoConnectionException(message: "teste erro connection");

      List<dynamic> data;
      _offSetGenrePage = 0;
      _isFinalListGenrePage = false;
      _paginationNumberGenrePage = 1;
      filterParams = params;

      switch (params.item1) {
        case Filter.all:
          data = await _instance
              .from(kDocumentTvShowAndMovies)
              .select()
              .contains("genres", _listGenres)
              .order(params.item2.value)
              .range(_offSetGenrePage,
                  (pageSize * _paginationNumberGenrePage) - 1);
          break;
        case Filter.movie:
          data = await _instance
              .from(kDocumentTvShowAndMovies)
              .select()
              .contains("genres", _listGenres)
              .eq("seasons", -1)
              .order(params.item2.value)
              .range(_offSetGenrePage,
                  (pageSize * _paginationNumberGenrePage) - 1);
          break;
        case Filter.tvShow:
          data = await _instance
              .from(kDocumentTvShowAndMovies)
              .select()
              .contains("genres", _listGenres)
              .neq("seasons", -1)
              .order(params.item2.value)
              .range(_offSetGenrePage,
                  (pageSize * _paginationNumberGenrePage) - 1);
          break;
      }
      if (data.isNotEmpty) {
        if (data.length == pageSize) {
          _offSetGenrePage += pageSize;
        } else {
          _offSetGenrePage += data.length;
          _isFinalListGenrePage = true;
        }
        _paginationNumberGenrePage += 1;
      }
      if (data.isEmpty) {
        _isFinalListGenrePage = true;
      }
      List<Map<String, dynamic>> map = data
          .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
          .toList();

      return Left(map);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<String, Tuple2<String, StackTrace>>> removeUser(
      String userId) async {
    try {
      await ConnectionVerifyer.verify();

      await _instance.rpc('remove_user_rating', params: {
        'id_user': userId,
      });
      await _instance.from(kDocumentUserHistory).delete().eq("idUser", userId);
      return const Left(Strings.sucessRemoveUser);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>> checkDeviceIdFromUser(
      UserHistoryModel userHistoryModel, String deviceId) async {
    try {
      await ConnectionVerifyer.verify();

      var result = await _instance
          .from(kDocumentUserHistory)
          .select()
          .eq("idUser", userHistoryModel.idUser)
          .eq("deviceId", deviceId);
      if (result.isEmpty) {
        return const Left(false);
      } else {
        return const Left(true);
      }
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //*TESTADO*//
  //Query<Map<String, dynamic>>
  getQueryByPagination(
    PaginationType paginationType,
  ) async {
    switch (paginationType) {
      case PaginationType.genrePage:
        return await _instance
            .from(kDocumentTvShowAndMovies)
            .select()
            .contains("genres", _listGenres)
            .range(
                _offSetGenrePage, (pageSize * _paginationNumberGenrePage) - 1);
      case PaginationType.genrePageFilter:
        switch (filterParams.item1) {
          case Filter.all:
            return await _instance
                .from(kDocumentTvShowAndMovies)
                .select()
                .contains("genres", _listGenres)
                .order(filterParams.item2.value)
                .range(_offSetGenrePage,
                    (pageSize * _paginationNumberGenrePage) - 1);
          case Filter.movie:
            return await _instance
                .from(kDocumentTvShowAndMovies)
                .select()
                .contains("genres", _listGenres)
                .eq("seasons", -1)
                .order(filterParams.item2.value)
                .range(_offSetGenrePage,
                    (pageSize * _paginationNumberGenrePage) - 1);
          case Filter.tvShow:
            return await _instance
                .from(kDocumentTvShowAndMovies)
                .select()
                .contains("genres", _listGenres)
                .neq("seasons", -1)
                .order(filterParams.item2.value)
                .range(_offSetGenrePage,
                    (pageSize * _paginationNumberGenrePage) - 1);
        }
    }
  }

  getQueryByPaginationMainPage(Filter filterMainPage) async {
    List<Tuple2<GenreType, List<Map<String, dynamic>>>> tuples = [];
    switch (filterMainPage) {
      case Filter.all:
        for (GenreType genre in kGenresList.sublist(
            _offSet,
            kGenresList.length > (pageSizeMainPage * _paginationNumber)
                ? (pageSizeMainPage * _paginationNumber)
                : kGenresList.length)) {
          var queryDocumentData = await _instance
              .from(kDocumentTvShowAndMovies)
              .select()
              .contains("genres", [genre.string])
              .limit(kMaxTvShowAndMoviesByGenre)
              .order("popularity");

          List<Map<String, dynamic>> map = queryDocumentData
              .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
              .toList();
          tuples.add(Tuple2(genre, map));
        }
        return tuples;
      case Filter.tvShow:
        for (GenreType genre in kGenresList.sublist(
            _offSet,
            kGenresList.length > (pageSizeMainPage * _paginationNumber)
                ? (pageSizeMainPage * _paginationNumber)
                : kGenresList.length)) {
          var queryDocumentData = await _instance
              .from(kDocumentTvShowAndMovies)
              .select()
              .contains("genres", [genre.string])
              .neq("seasons", -1)
              .limit(kMaxTvShowAndMoviesByGenre)
              .order("popularity");

          List<Map<String, dynamic>> map = queryDocumentData
              .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
              .toList();
          tuples.add(Tuple2(genre, map));
        }
        return tuples;

      case Filter.movie:
        debugPrint(kGenresList.toString());
        debugPrint(
            "from $_offSet to ${kGenresList.length > (pageSizeMainPage * _paginationNumber) ? (pageSizeMainPage * _paginationNumber) : kGenresList.length}");
        for (GenreType genre in kGenresList.sublist(
            _offSet,
            kGenresList.length > (pageSizeMainPage * _paginationNumber)
                ? (pageSizeMainPage * _paginationNumber)
                : kGenresList.length)) {
          var queryDocumentData = await _instance
              .from(kDocumentTvShowAndMovies)
              .select()
              .contains("genres", [genre.string])
              .eq("seasons", -1)
              .limit(kMaxTvShowAndMoviesByGenre)
              .order("popularity");

          List<Map<String, dynamic>> map = queryDocumentData
              .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
              .toList();
          tuples.add(Tuple2(genre, map));
        }
        return tuples;
    }
  }
}
