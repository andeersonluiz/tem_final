import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tem_final/src/core/resources/connection_verifyer.dart';
import 'package:tem_final/src/core/resources/no_connection_exception.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_model.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_rating_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tem_final/src/data/models/user_rating_model.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_rating_entity.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
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
      print("_isFinalList é $_isFinalList");
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
      _offSet = 0;
      _paginationNumber = 1;
      _isFinalList = false;
      _querySearch = query.trim().toLowerCase();
      //TEM QUE ORDENAR
      var queryDocumentData = await _instance
          .from(kDocumentTvShowAndMovies)
          .select()
          .contains("caseSearch", [_querySearch]).range(
              _offSet, pageSize * _paginationNumber);

      if (queryDocumentData.isNotEmpty) {
        if (queryDocumentData.length == pageSize) {
          _offSet += pageSize;
        } else {
          _offSet += int.parse(queryDocumentData.length);
          _isFinalList = true;
        }
        _paginationNumber += 1;
      }
      if (queryDocumentData.isEmpty) {
        _isFinalList = true;
      }
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
      int seasonId, String id, ConclusionType conclusionType) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");

      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');

      switch (conclusionType) {
        case ConclusionType.conclusive:
          await _instance.rpc('increment_info_season', params: {
            'p_index': seasonId,
            'p_field': 'unknownCount',
            'p_id': id
          });
          break;
        case ConclusionType.openEnded:
          await _instance.rpc('increment_info_season', params: {
            'p_index': seasonId,
            'p_field': 'openEndedCount',
            'p_id': id
          });
          break;
        case ConclusionType.unknown:
          await _instance.rpc('increment_info_season', params: {
            'p_index': seasonId,
            'p_field': 'unknownCount',
            'p_id': id
          });
          break;
      }
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
    print("_isFinalList é $_isFinalList");

    if (_isFinalList) return const Left([]);
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      print("chmei moreData");
      var moreData = (await getQueryByPaginationMainPage(filterMainPage));
      print("moreData ${moreData.length}");
      print(pageSizeMainPage);
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

      return Left(true);
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
      print(tvShowAndMovieRating.toMap().toString());
      print(int.parse(idTvShowAndMovie));

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
  String _getErrorFromFirebaseExceptionByCode(String code) {
    switch (code.toUpperCase()) {
      case 'ABORTED':
        return Strings.aborted;
      case 'ALREADY_EXISTS':
        return Strings.alreadyExists;
      case 'CANCELLED':
        return Strings.cancelled;
      case 'DATA_LOSS':
        return Strings.dataLoss;
      case 'DEADLINE_EXCEEDED':
        return Strings.deadlineExceeded;
      case 'FAILED_PRECONDITION':
        return Strings.failedPrecondition;
      case 'INTERNAL':
        return Strings.internal;
      case 'INVALID_ARGUMENT':
        return Strings.invalidArgument;
      case 'NOT_FOUND':
        return Strings.notFound;
      case 'OK':
        return Strings.ok;
      case 'OUT_OF_RANGE':
        return Strings.outOfRange;
      case 'PERMISSION_DENIED':
        return Strings.permissionDenied;
      case 'RESOURCE_EXHAUSTED':
        return Strings.resourceExhausted;
      case 'UNAUTHENTICATED':
        return Strings.unauthenticated;
      case 'UNAVAILABLE':
        return Strings.unavailable;
      case 'UNIMPLEMENTED':
        return Strings.unimplemented;
      case 'UNKNOWN':
        return Strings.unknown;
      default:
        return Strings.defaultErrorFirebase + code;
    }
  }

  //*TESTADO*//
  //Query<Map<String, dynamic>>
  getQueryByPagination(PaginationType paginationType) async {
    switch (paginationType) {
      case PaginationType.searchPage:
        return await _instance
            .from(kDocumentTvShowAndMovies)
            .select()
            .contains("caseSearch", [_querySearch]).range(
                _offSet, pageSize * _paginationNumber);
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
        print(kGenresList);
        print(
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
