import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tem_final/src/core/resources/connection_verifyer.dart';
import 'package:tem_final/src/core/resources/no_connection_exception.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_rating_model.dart';
import 'package:tem_final/src/data/models/user_choice_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tuple/tuple.dart';
import '../../../core/utils/strings.dart';

class FirebaseHandlerService {
  FirebaseHandlerService() {
    _instance = Supabase.instance.client;
  }
  late SupabaseClient _instance;
  late bool _isFinalList;
  late String _querySearch;
  late List<String> _listGenres;
  late int _offSet = 0;
  late int _paginationNumber = 1;

//* TESTADO *//
  Future<
      Either<List<Tuple2<String, List<Map<String, dynamic>>>>,
          Tuple2<String, StackTrace>>> getAllTvShowAndMovie() async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _offSet = 0;
      _paginationNumber = 1;
      _isFinalList = false;
      List<Tuple2<String, List<Map<String, dynamic>>>> tuples = [];

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
        tuples.add(Tuple2(genre.string, map));
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
      Either<List<Tuple2<String, List<Map<String, dynamic>>>>,
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
      List<Tuple2<String, List<Map<String, dynamic>>>> tuples = [];

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
        tuples.add(Tuple2(genre.string, map));
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
      Either<List<Tuple2<String, List<Map<String, dynamic>>>>,
          Tuple2<String, StackTrace>>> getAllTvShow() async {
    try {
      await ConnectionVerifyer.verify();

      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _offSet = 0;
      _paginationNumber = 1;
      _isFinalList = false;
      debugPrint("_isFinalList é $_isFinalList");
      //TEM QUE SORTEAR
      List<Tuple2<String, List<Map<String, dynamic>>>> tuples = [];

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
        tuples.add(Tuple2(genre.string, map));
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
      print(userHistoryModel.toMap());
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
      String subject,
      String message,
      ReportType reportType,
      String idTvShowAndMovie) async {
    try {
      await ConnectionVerifyer.verify();

      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');

      String messageResult = reportType.string;
      var result = await _instance
          .from(kDocumentTvShowAndMovies)
          .select()
          .eq("id", idTvShowAndMovie);
      bool hasErrorFindId = false;

      if (result.isEmpty) {
        hasErrorFindId = true;
      }
      await _instance.from("reports").insert({
        "subject": subject,
        "message": message,
        "reportType": messageResult,
        "idTvShowAndMovie": int.parse(idTvShowAndMovie),
        "hasErrorId": hasErrorFindId
      });

      switch (reportType) {
        case ReportType.problem:
          messageResult += Strings.msgSufixReportProblem;
          break;
        case ReportType.feedback:
          messageResult += Strings.msgSufixReportFeedback;
          break;
        case ReportType.changeData:
          messageResult += Strings.msgSufixReportChangedData;
          break;
      }

      return Left(messageResult);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //*TESTADO*//
  Future<Either<List<Map<String, dynamic>>, Tuple2<String, StackTrace>>>
      loadMoreTvShowAndMovies(PaginationType paginationType) async {
    if (_isFinalList) return const Left([]);
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      var moreData = (await getQueryByPagination(paginationType));

      if (moreData.isNotEmpty) {
        if (moreData.length == pageSize) {
          _offSet += pageSize;
        } else {
          _offSet += int.parse(moreData.length);
          _isFinalList = true;
        }
        _paginationNumber += 1;
      }
      if (moreData.isEmpty) {
        _isFinalList = true;
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
      Either<List<Tuple2<String, List<Map<String, dynamic>>>>,
          Tuple2<String, StackTrace>>> loadMoreTvShowAndMoviesMainPage(
      Filter filterMainPage) async {
    debugPrint("_isFinalList é $_isFinalList");

    if (_isFinalList) return const Left([]);
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      debugPrint("chmei moreData");
      var moreData = (await getQueryByPaginationMainPage(filterMainPage));
      debugPrint("moreData ${moreData.length}");
      debugPrint(pageSizeMainPage.toString());
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
      getTvSeriesAndMovieByGenres(List<GenreType> genres) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _offSet = 0;
      _isFinalList = false;
      _paginationNumber = 1;
      _listGenres = genres.map((e) => e.string).toList();
      var data = await _instance
          .from(kDocumentTvShowAndMovies)
          .select()
          .containedBy("genres", _listGenres)
          .range(_offSet, pageSize * _paginationNumber);

      if (data.isNotEmpty) {
        if (data.length == pageSize) {
          _offSet += pageSize;
        } else {
          _offSet += int.parse(data.length);
          _isFinalList = true;
        }
        _paginationNumber += 1;
      }
      if (data.isEmpty) {
        _isFinalList = true;
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
          .insert(userHistoryModel.toMap());

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
      debugPrint(tvShowAndMovieRating.toMap().toString());
      debugPrint(int.parse(idTvShowAndMovie).toString());

      await _instance.rpc('update_rating_list', params: {
        'p_id': int.parse(idTvShowAndMovie),
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

  //* TESTADO *//

  //*TESTADO*//
  //Query<Map<String, dynamic>>
  getQueryByPagination(PaginationType paginationType) async {
    switch (paginationType) {
      case PaginationType.genrePage:
        return await _instance
            .from(kDocumentTvShowAndMovies)
            .select()
            .containedBy("genres", _listGenres)
            .range(_offSet, pageSize * _paginationNumber);
    }
  }

  getQueryByPaginationMainPage(Filter filterMainPage) async {
    List<Tuple2<String, List<Map<String, dynamic>>>> tuples = [];
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
          tuples.add(Tuple2(genre.string, map));
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
          tuples.add(Tuple2(genre.string, map));
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
          tuples.add(Tuple2(genre.string, map));
        }
        return tuples;
    }
  }
}
