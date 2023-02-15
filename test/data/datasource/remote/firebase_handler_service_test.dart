import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tem_final/src/core/resources/connection_verifyer.dart';
import 'package:tem_final/src/core/resources/no_connection_exception.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tuple/tuple.dart';

class MockFirebaseHandlerService {
  MockFirebaseHandlerService() {
    _instance = FakeFirebaseFirestore();
  }
  late FakeFirebaseFirestore _instance;
  late QueryDocumentSnapshot<Map<String, dynamic>>
      _lastDocumentTvSeriesAndMovies;

  late bool _isFinalList;
  late String _querySearch;
  late List<String> _listGenres;
  init() async {
    _instance = FakeFirebaseFirestore();
    _isFinalList = false;
    var file = await rootBundle.loadString('assets/dataUpdated.json');
    var result = jsonDecode(file);
    var data = result
        .take(500)
        .map((item) => TvShowAndMovieModel.fromMap(item))
        .toList();
    for (var item in data.take(500)) {
      await _instance.collection(kDocumentTvShowAndMovies).add(item.toMap());
    }
    var file2 = await rootBundle.loadString('assets/dataUserHistory.json');
    var result2 = jsonDecode(file2);
    var data2 = result2.map((item) => UserHistoryModel.fromMap(item)).toList();
    for (var item in data2) {
      await _instance.collection(kDocumentUserHistory).add(item.toMap());
    }
    debugPrint("data test initialized");
  }

  //* TESTADO *//
  Future<Either<List<Map<String, dynamic>>, Tuple2<String, StackTrace>>>
      getAllTvShowAndMovie() async {
    try {
      await ConnectionVerifyer.verify();

      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _isFinalList = false;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> queryDocumentData =
          (await _instance
                  .collection(kDocumentTvShowAndMovies)
                  .orderBy("viewsCount")
                  .get())
              .docs;

      return Left(queryDocumentData.map((e) => e.data()).toList());
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<List<Map<String, dynamic>>, Tuple2<String, StackTrace>>>
      getAllMovie() async {
    try {
      await ConnectionVerifyer.verify();

      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _isFinalList = false;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> queryDocumentData =
          (await _instance
                  .collection(kDocumentTvShowAndMovies)
                  .where("seasons", isEqualTo: -1)
                  .orderBy("viewsCount")
                  .get())
              .docs;

      return Left(queryDocumentData.map((e) => e.data()).toList());
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<List<Map<String, dynamic>>, Tuple2<String, StackTrace>>>
      getAllTvShow() async {
    try {
      await ConnectionVerifyer.verify();

      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      _isFinalList = false;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> queryDocumentData =
          (await _instance
                  .collection(kDocumentTvShowAndMovies)
                  .where("seasons", isNotEqualTo: -1)
                  .orderBy("viewsCount")
                  .get())
              .docs;

      return Left(queryDocumentData.map((e) => e.data()).toList());
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
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
      List<QueryDocumentSnapshot<Map<String, dynamic>>> queryDocumentData =
          (await _instance
                  .collection(kDocumentTvShowAndMovies)
                  .where("id", isEqualTo: id)
                  .limit(1)
                  .get())
              .docs;

      var data = queryDocumentData.map((e) => e.data()).toList();
      if (data.isEmpty) {
        return const Left({});
      }
      return Left(data.first);
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
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

      _isFinalList = false;
      _querySearch = query.trim().toLowerCase();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> queryDocumentData =
          (await _instance
                  .collection(kDocumentTvShowAndMovies)
                  .where("caseSearch", arrayContains: _querySearch)
                  .orderBy("viewsCount")
                  .limit(pageSize)
                  .get())
              .docs;
      if (queryDocumentData.isNotEmpty) {
        _lastDocumentTvSeriesAndMovies = queryDocumentData.last;
      }

      if (queryDocumentData.length < pageSize) {
        _isFinalList = true;
      }
      return Left(queryDocumentData.map((e) => e.data()).toList());
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  //* TESTADO *//
  Future<Either<String, Tuple2<String, StackTrace>>> selectConclusion(
      String id, ConclusionType conclusionType) async {
    try {
      await ConnectionVerifyer.verify();
      //throw Exception("teste");
      //throw NoConnectionException(message: "teste erro connection");
      //throw FirebaseException(plugin: 'firebase');
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data = (await _instance
              .collection(kDocumentTvShowAndMovies)
              .where("id", isEqualTo: id)
              .limit(1)
              .get())
          .docs;
      if (data.isEmpty) {
        return const Right(Tuple2(
            Strings.msgSerieAndMovieNotFoundSelectConclusion,
            StackTrace.empty));
      }
      switch (conclusionType) {
        case ConclusionType.conclusive:
          await _instance
              .collection(kDocumentTvShowAndMovies)
              .doc(data.first.reference.id)
              .update({"conclusiveCount": FieldValue.increment(1)});
          break;
        case ConclusionType.openEnded:
          await _instance
              .collection(kDocumentTvShowAndMovies)
              .doc(data.first.reference.id)
              .update({"openEndedCount": FieldValue.increment(1)});
          break;
        case ConclusionType.unknown:
          await _instance
              .collection(kDocumentTvShowAndMovies)
              .doc(data.first.reference.id)
              .update({"unknownCount": FieldValue.increment(1)});
          break;
      }
      return const Left(Strings.msgSucessSelectConclusion);
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
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
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data = (await _instance
              .collection(kDocumentTvShowAndMovies)
              .where("id", isEqualTo: idTvShowAndMovieModel)
              .limit(1)
              .get())
          .docs;
      if (data.isEmpty) {
        return const Right(Tuple2(
            Strings.msgSerieAndMovieNotFoundIncrementTvShowAndMovieViewCount,
            StackTrace.empty));
      }
      await _instance
          .collection(kDocumentTvShowAndMovies)
          .doc(data.first.reference.id)
          .update({"viewsCount": FieldValue.increment(1)});
      return const Left(null);
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
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
      bool hasErrorFindId = false;
      if (idTvShowAndMovie != "") {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
            (await _instance
                    .collection(kDocumentTvShowAndMovies)
                    .where("id", isEqualTo: idTvShowAndMovie)
                    .limit(1)
                    .get())
                .docs;
        if (data.isEmpty) {
          hasErrorFindId = true;
        }
      }

      String messageResult = reportType.string;

      await _instance.collection("reports").add({
        "subject": subject,
        "message": message,
        "reportType": messageResult,
        "idTvShowAndMovie": idTvShowAndMovie,
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
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
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
      List<QueryDocumentSnapshot<Map<String, dynamic>>> moreData =
          (await getQueryByPagination(paginationType)
                  .startAfterDocument(_lastDocumentTvSeriesAndMovies)
                  .limit(pageSize)
                  .get())
              .docs;
      _lastDocumentTvSeriesAndMovies = moreData.last;
      if (moreData.length < pageSize) {
        _isFinalList = true;
      }
      return Left(moreData.map((e) => e.data()).toList());
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
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
      _listGenres = genres.map((e) => e.string).toList();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data = (await _instance
              .collection(kDocumentTvShowAndMovies)
              .where("genres", arrayContainsAny: _listGenres)
              .orderBy("viewsCount")
              .limit(pageSize)
              .get())
          .docs;

      if (data.isNotEmpty) {
        _lastDocumentTvSeriesAndMovies = data.last;
      }
      if (data.length < pageSize) {
        _isFinalList = true;
      }
      return Left(data.map((e) => e.data()).toList());
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
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
      var data = (await _instance
              .collection(kDocumentUserHistory)
              .where("idUser", isEqualTo: userId)
              .get())
          .docs;
      UserHistoryModel? userHistoryModel;

      if (data.isEmpty) {
        userHistoryModel = null;
      } else {
        userHistoryModel = UserHistoryModel.fromMap(data.first.data());
      }
      return Left(userHistoryModel);
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<bool, Tuple2<String, StackTrace>>> ratingTvShowAndMovie(
      String idUser, UserHistoryModel userHistoryModel) async {
    try {
      var data = (await _instance
              .collection(kDocumentUserHistory)
              .where("idUser", isEqualTo: idUser)
              .get())
          .docs;
      if (data.isEmpty) {
        return const Right(
            Tuple2(Strings.userNotFoundFirebase, StackTrace.empty));
      } else {
        await _instance
            .collection(kDocumentUserHistory)
            .doc(data.first.id)
            .update(userHistoryModel.toMap());
      }
      return const Left(true);
    } on FirebaseException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseExceptionByCode(e.code), stacktrace));
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
  Query<Map<String, dynamic>> getQueryByPagination(
      PaginationType paginationType) {
    switch (paginationType) {
      case PaginationType.searchPage:
        return _instance
            .collection(kDocumentTvShowAndMovies)
            .where("caseSearch", arrayContains: _querySearch)
            .orderBy("viewsCount");
      case PaginationType.genrePage:
        return _instance
            .collection(kDocumentTvShowAndMovies)
            .where("genres", arrayContainsAny: _listGenres)
            .orderBy("viewsCount");
    }
  }
  //*APENAS PARA TESTES*//

  getAllReports() async {
    return (await _instance.collection("reports").get())
        .docs
        .map((e) => e.data());
  }
}
