import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/data/mappers/tv_show_and_movie_mapper.dart';
import 'package:tem_final/src/data/mappers/user_history_mapper.dart';
import 'package:tem_final/src/data/models/tv_show_and_movie_model.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/repositories/data_integrity_checker_repository.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';
import 'package:tuple/tuple.dart';

import '../../domain/usecases/get_all_tv_show_and_move_with_favorite_usecase_test.dart';
import '../../domain/usecases/get_all_tv_show_and_movie_usecase_test.dart';
import '../../domain/usecases/log_out_usecase_test.dart';
import '../../domain/usecases/login_via_google_usecase_test.dart';
import '../../injection_test.dart';
import '../datasource/auth/firebase_auth_handler_service_test.dart';
import '../datasource/local/local_preferences_handler_service_test.dart';
import '../datasource/remote/firebase_handler_service_test.dart';

class MockTvShowAndMovieRepositoryImpl extends Mock
    implements TvShowAndMovieRepository {
  MockTvShowAndMovieRepositoryImpl(
      {required this.firebaseHandlerService,
      required this.firebaseAuthHandlerService,
      required this.localPreferencesHandlerService,
      required this.mapper,
      required this.userHistoryMapper,
      required this.userId});

  final MockFirebaseHandlerService firebaseHandlerService;
  MockFirebaseAuthHandlerService firebaseAuthHandlerService;
  final MockLocalPreferencesHandlerService localPreferencesHandlerService;
  UserHistoryMapper userHistoryMapper;
  final TvShowAndMovieMapper mapper;
  final String userId;

  @override
  Future<DataState<bool>> ratingTvShowAndMovie(UserHistory userHistory) async {
    UserHistoryModel userHistoryModel =
        userHistoryMapper.entityToModel(userHistory);
    var resultRating = await firebaseHandlerService.ratingTvShowAndMovie(
        userId, userHistoryModel);

    if (resultRating.isLeft) {
      var resultUpdateUserHistory = await localPreferencesHandlerService
          .updateUserHistory(userHistoryModel);

      if (resultUpdateUserHistory.isLeft) {
        return DataSucess(true);
      } else {
        return DataFailed(resultUpdateUserHistory.right, isLog: false);
      }
    } else {
      return DataFailed(resultRating.right, isLog: false);
    }
  }

  @override
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      getAllTvShowAndMovie() async {
    var firebaseResponse = await firebaseHandlerService.getAllTvShowAndMovie();

    if (firebaseResponse.isLeft) {
      var firebaseData = firebaseResponse.left;
      List<TvShowAndMovie> listTvShowAndMovie = firebaseData
          .map(
              (item) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(item)))
          .toList();

      return DataSucess(_convertToTuple(listTvShowAndMovie));
    }
    return DataFailed(firebaseResponse.right, isLog: false);
  }

  @override
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      getAllMovie() async {
    var firebaseResponse = await firebaseHandlerService.getAllMovie();

    if (firebaseResponse.isLeft) {
      var firebaseData = firebaseResponse.left;
      List<TvShowAndMovie> listTvShowAndMovie = firebaseData
          .map(
              (item) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(item)))
          .toList();

      return DataSucess(_convertToTuple(listTvShowAndMovie));
    }
    return DataFailed(firebaseResponse.right, isLog: false);
  }

  @override
  Future<DataState<List<Tuple2<String, List<TvShowAndMovie>>>>>
      getAllTvShow() async {
    var firebaseResponse = await firebaseHandlerService.getAllTvShow();

    if (firebaseResponse.isLeft) {
      var firebaseData = firebaseResponse.left;
      List<TvShowAndMovie> listTvShowAndMovie = firebaseData
          .map(
              (item) => mapper.modelToEntity(TvShowAndMovieModel.fromMap(item)))
          .toList();

      return DataSucess(_convertToTuple(listTvShowAndMovie));
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
            params.item1, params.item2);

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

  List<Tuple2<String, List<TvShowAndMovie>>> _convertToTuple(
      List<TvShowAndMovie> listTvShowAndMovie) {
    List<Tuple2<String, List<TvShowAndMovie>>> tupleList = [];
    List<String> genresFilled = [];
    for (TvShowAndMovie tvShowAndMovie in listTvShowAndMovie) {
      for (String genre in tvShowAndMovie.genres) {
        if (genresFilled.contains(genre)) continue;
        var indexGenre =
            tupleList.indexWhere((element) => element.item1 == genre);
        if (indexGenre == -1) {
          tupleList.add(Tuple2(genre, [tvShowAndMovie]));
        } else {
          tupleList[indexGenre].item2.add(tvShowAndMovie);
          if (tupleList[indexGenre].item2.length ==
              kMaxTvShowAndMoviesByGenre) {
            genresFilled.add(genre);
            tupleList[indexGenre].item2.shuffle();
          }
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

  //*APENAS PARA TESTES*//
  getAllReports() async {
    return await firebaseHandlerService.getAllReports();
  }

  Future<Either<String, Tuple2<String, StackTrace>>> getUserId() async {
    return await localPreferencesHandlerService.loadUserId();
  }

  Future<void> changeData() async {
    await localPreferencesHandlerService.changeData();
  }
}

class MockUserRepositoryImpl implements UserRepository {
  MockUserRepositoryImpl(
      {required this.firebaseHandlerService,
      required this.firebaseAuthHandlerService,
      required this.localPreferencesHandlerService,
      required this.userHistoryMapper});
  final MockFirebaseHandlerService firebaseHandlerService;
  final MockFirebaseAuthHandlerService firebaseAuthHandlerService;
  final MockLocalPreferencesHandlerService localPreferencesHandlerService;
  final UserHistoryMapper userHistoryMapper;
  @override
  Future<DataState<String>> logOut() async {
    var logOutResult = await firebaseAuthHandlerService.logOut();
    if (logOutResult.isLeft) {
      await localPreferencesHandlerService.clearUserHistory();
      await localPreferencesHandlerService.clearUserId();
      return DataSucess(logOutResult.left);
    } else {
      return DataFailed(logOutResult.right, isLog: false);
    }
  }

  @override
  Future<DataState<String>> loginViaGoogle() async {
    var loginResult = await firebaseAuthHandlerService.loginViaGoogle();
    if (loginResult.isLeft) {
      Either<bool, Tuple2<String, StackTrace>> resulSetUserId =
          await localPreferencesHandlerService.setUserId(loginResult.left);
      DataState<bool> resultLoadUserHistory =
          await _loadUserHistory(loginResult.left);
      if (resulSetUserId.isLeft && resultLoadUserHistory is DataSucess) {
        return const DataSucess(Strings.loginSucess);
      } else {
        String stackTraceSetUserId = resulSetUserId.isRight
            ? resulSetUserId.right.item2.toString()
            : "no has error";
        String stackTraceLoadUserHistory = resultLoadUserHistory is DataFailed
            ? resultLoadUserHistory.error!.toString()
            : "no has error";

        return DataFailed(
            Tuple2(
                Strings.loginError,
                StackTrace.fromString(
                    "setUserId: $stackTraceSetUserId | loadUserHistory: $stackTraceLoadUserHistory")),
            isLog: false);
      }
    } else {
      return DataFailed(loginResult.right, isLog: false);
    }
  }

  Future<Either<String, Tuple2<String, StackTrace>>> getUserId() async {
    return await localPreferencesHandlerService.loadUserId();
  }

  @override
  Future<DataState<String>> submitReport(
    Tuple4<String, String, ReportType, String> params,
  ) async {
    Either<String, Tuple2<String, StackTrace>> submitResponse =
        await firebaseHandlerService.submitReport(
            params.item1, params.item2, params.item3, params.item4);

    if (submitResponse.isLeft) {
      return DataSucess(submitResponse.left);
    }
    return DataFailed(submitResponse.right, isLog: false);
  }

  Future<DataState<bool>> _loadUserHistory(String userId) async {
    Either<UserHistoryModel?, Tuple2<String, StackTrace>> resultUserHistory =
        await firebaseHandlerService.getUserHistory(userId);
    if (resultUserHistory.isLeft) {
      UserHistoryModel? userHistoryModel = resultUserHistory.left;
      userHistoryModel ??= UserHistoryModel(
          idUser: userId, listUserChoices: [], listUserRatings: []);

      Either<bool, Tuple2<String, StackTrace>> resultUpdateUserHistory =
          await localPreferencesHandlerService
              .updateUserHistory(userHistoryModel);
      if (resultUpdateUserHistory.isLeft) {
        return DataSucess(resultUpdateUserHistory.left);
      } else {
        return DataFailed(resultUpdateUserHistory.right, isLog: false);
      }
    } else {
      return DataFailed(resultUserHistory.right, isLog: false);
    }
  }

  @override
  Future<DataState<UserHistory?>> getLocalUserHistory() async {
    Either<UserHistoryModel?, Tuple2<String, StackTrace>> resultGetUserHistory =
        localPreferencesHandlerService.getUserHistory();

    if (resultGetUserHistory.isLeft) {
      if (resultGetUserHistory.left == null) return const DataSucess(null);

      return DataSucess(
          userHistoryMapper.modelToEntity(resultGetUserHistory.left!));
    } else {
      return DataFailed(resultGetUserHistory.right, isLog: false);
    }
  }
}

class MockDataIntegrityCheckerRepositoryImpl implements DataIntegrityChecker {
  MockDataIntegrityCheckerRepositoryImpl({
    required this.firebaseHandlerService,
    required this.firebaseAuthHandlerService,
    required this.localPreferencesHandlerService,
    required this.userRepository,
  });
  final MockFirebaseHandlerService firebaseHandlerService;
  final MockFirebaseAuthHandlerService firebaseAuthHandlerService;
  final MockLocalPreferencesHandlerService localPreferencesHandlerService;
  final UserRepository userRepository;

  @override
  Future<void> checkIntegrity() async {
    await localPreferencesHandlerService.checkFavoriteTvShowAndMovieIntegrity();
    await localPreferencesHandlerService
        .checkUserViewedTvShowAndMovieIntegrity();
    await localPreferencesHandlerService
        .checkUserViewedTvShowAndMovieIntegrity();
    var resultUserHistoryIntegrity =
        await localPreferencesHandlerService.checkUserHistoryIntegrity();
    if (!resultUserHistoryIntegrity) {
      await userRepository.logOut();
    }
  }

  @override
  Future<DataState<bool>> checkMultiDeviceLoginStatus() async {
    var idFromFirestore =
        await firebaseAuthHandlerService.getUserIdFromAuthFirestore();
    var localId = await localPreferencesHandlerService.loadUserId();
    if (idFromFirestore.isLeft && localId.isLeft) {
      if (idFromFirestore != localId) {
        await userRepository.logOut();
        return const DataSucess(true);
      }
    }
    String stackTraceidFromFirestore = idFromFirestore.isRight
        ? idFromFirestore.right.item2.toString()
        : "no has error";
    String stackTraceLocalId =
        localId.isRight ? localId.right.item2.toString() : "no has error";

    return DataFailed(
        Tuple2(
            Strings.multiDeviceError,
            StackTrace.fromString(
                "idFromFirestore: $stackTraceidFromFirestore | localId: $stackTraceLocalId")),
        isLog: true);
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MockFirebaseHandlerService firebaseHandlerService;
  MockLocalPreferencesHandlerService localPreferencesHandlerService;
  TvShowAndMovieMapper mapper;
  UserHistoryMapper userHistoryMapper;
  String userId;
  late MockTvShowAndMovieRepositoryImpl tvShowAndMovieRepository;
  late MockUserRepositoryImpl mockUserRepositoryImpl;
  late MockDataIntegrityCheckerRepositoryImpl
      dataIntegrityCheckerRepositoryImpl;

  setUp(() async {
    firebaseHandlerService = MockFirebaseHandlerService();
    await firebaseHandlerService.init();

    localPreferencesHandlerService = MockLocalPreferencesHandlerService();
    await localPreferencesHandlerService.init();
    mapper = TvShowAndMovieMapper();
    userHistoryMapper = UserHistoryMapper();
    MockFirebaseAuthHandlerService mockFirebaseAuthHandlerService =
        MockFirebaseAuthHandlerService();
    userId = 'UserId';
    tvShowAndMovieRepository = MockTvShowAndMovieRepositoryImpl(
      firebaseHandlerService: firebaseHandlerService,
      localPreferencesHandlerService: localPreferencesHandlerService,
      mapper: mapper,
      userId: userId,
      firebaseAuthHandlerService: mockFirebaseAuthHandlerService,
      userHistoryMapper: userHistoryMapper,
    );
    mockUserRepositoryImpl = MockUserRepositoryImpl(
        firebaseHandlerService: firebaseHandlerService,
        firebaseAuthHandlerService: mockFirebaseAuthHandlerService,
        localPreferencesHandlerService: localPreferencesHandlerService,
        userHistoryMapper: userHistoryMapper);
    dataIntegrityCheckerRepositoryImpl = MockDataIntegrityCheckerRepositoryImpl(
        firebaseHandlerService: firebaseHandlerService,
        firebaseAuthHandlerService: mockFirebaseAuthHandlerService,
        localPreferencesHandlerService: localPreferencesHandlerService,
        userRepository: mockUserRepositoryImpl);
  });

  group('testando funcionalidades do firebase', () {
    test(
        "Deve retornar uma lista do tipo DataState e Tuple2<String, StackTrace> no caso de erro",
        () async {
      var result = await tvShowAndMovieRepository.getAllTvShowAndMovie();
      if (result is DataFailed) {
        debugPrint("DataFailed");
        debugPrint(result.error!.item1);
        debugPrint(result.error!.item2.toString());
      } else {
        debugPrint("DataSucess");
        debugPrint(result.data!.length.toString());
        debugPrint(result.data!.first.toString());
      }
    });
    test(
        "Deve retornar um objeto do tipo DataState<TvShowAndMovie?> e e Tuple2<String, StackTrace> no caso de erro",
        () async {
      var result =
          await tvShowAndMovieRepository.getTvShowAndMovie("302017723");
      if (result is DataFailed) {
        debugPrint("DataFailed");
        debugPrint(result.error!.item1);
        debugPrint(result.error!.item2.toString());
      } else {
        debugPrint("DataSucess");
        if (result.data == null) {
          debugPrint("não há resultados para busca");
        } else {
          debugPrint(result.data!.toString());
        }
      }
    });
    test(
        "Deve retornar uma lista de objetos do tipo DataState<List<TvShowAndMovie>> de acordo com a busca e Tuple2<String, StackTrace> no caso de erro",
        () async {
      var query = " al ".trim();
      var result = await tvShowAndMovieRepository.searchTvShowAndMovie(query);
      if (result is DataFailed) {
        debugPrint("DataFailed");
        debugPrint(result.error!.item1);
        debugPrint(result.error!.item2.toString());
      } else {
        debugPrint("DataSucess");
        if (result.data!.isEmpty) {
          debugPrint("não há resultados para busca: $query");
        } else {
          debugPrint("resulados para busca: $query");
          debugPrint(result.data!.length.toString());
          debugPrint(result.data!.map((e) => e.title).toList().toString());
        }
      }
    });

    test(
        "Deve retornar uma String representado uma resposta positiva ou e Tuple2<String, StackTrace> no caso de erro",
        () async {
      var id = "3020177231";
      ConclusionType conclusionType = ConclusionType.unknown;
      var result = await tvShowAndMovieRepository
          .selectConclusion(Tuple2(id, conclusionType));
      if (result is DataFailed) {
        debugPrint("DataFailed");
        debugPrint(result.error!.item1);
        debugPrint(result.error!.item2.toString());
      } else {
        debugPrint("DataSucess");
        debugPrint(
            "atualização realizada com sucesso do campo $conclusionType");
        var result = await tvShowAndMovieRepository.getTvShowAndMovie(id);
        debugPrint(result.data.toString());
      }
    });

    test(
        "Deve retornar uma String representado uma resposta positiva ou e Tuple2<String, StackTrace> no caso de erro",
        () async {
      var id = "";
      ReportType reportType = ReportType.problem;
      var result = await mockUserRepositoryImpl
          .submitReport(Tuple4("subject", "message", reportType, ""));
      if (result is DataFailed) {
        debugPrint("DataFailed");
        debugPrint(result.error!.item1);
        debugPrint(result.error!.item2.toString());
      } else {
        debugPrint("DataSucess");
        debugPrint("report($reportType) enviado com sucesso");

        if (id != "") {
          var result = await tvShowAndMovieRepository.getTvShowAndMovie(id);
          if (result is DataSucess) {
            if (result.data == null) {
              debugPrint("id no Exists");
            } else {
              debugPrint("idExists");
              debugPrint(result.data!.title.toString());
            }
          } else {
            debugPrint("error");
          }
        }
        var result = await tvShowAndMovieRepository.getAllReports();
        debugPrint("reports: $result");
      }
    });

    test("Testando carregamento infinito de PaginationType.searchPage",
        () async {
      var query = " a ".trim();
      var result = await tvShowAndMovieRepository.searchTvShowAndMovie(query);
      List<String> myList = [];
      if (result is DataFailed) {
        debugPrint("DataFailed");
      } else {
        myList.addAll(result.data!.map((e) => e.id));
      }
      DataState<List<TvShowAndMovie>> resultPagination;
      int count = 10;
      while (true) {
        if (count == 0) {
          break;
        }
        count -= 1;
        resultPagination = await tvShowAndMovieRepository
            .loadMoreTvShowAndMovie(PaginationType.searchPage);
        if (resultPagination is DataFailed) {
          debugPrint("DataFailed");
          debugPrint(resultPagination.error!.item1.toString());
          debugPrint(resultPagination.error!.item2.toString());
        } else {
          if (resultPagination.data!.isEmpty) {
            debugPrint("Fim da lista");
            break;
          }
          myList.addAll(resultPagination.data!.map((e) => e.id));
        }
      }
      debugPrint(myList.toString());
      debugPrint(myList.length.toString());
      if (myList
          .where((string) =>
              myList.where((item) => item == string).toList().length > 1)
          .isNotEmpty) {
        debugPrint("há elementos repetidos na lista");
      } else {
        debugPrint("não há elementos repetidos na lista");
      }
    });
    test("teste de funçaõ que retorna por generos", () async {
      List<GenreType> genres = [GenreType.actionAdventure, GenreType.crime];
      var result =
          await tvShowAndMovieRepository.getTvShowAndMovieByGenres(genres);
      if (result is DataFailed) {
        debugPrint("DataFailed");
        debugPrint(result.error!.item1);
        debugPrint(result.error!.item2.toString());
      } else {
        debugPrint("DataSucess");
        debugPrint(result.data!.length.toString());
        debugPrint(result.data!.map((item) => item.genres).toList().toString());
        debugPrint(result.data!.first.toString());
      }
    });

    test("Testando carregamento infinito de PaginationType.genrePage",
        () async {
      List<GenreType> genres = [GenreType.actionAdventure, GenreType.crime];
      var result =
          await tvShowAndMovieRepository.getTvShowAndMovieByGenres(genres);
      List<String> myList = [];
      if (result is DataFailed) {
        debugPrint("DataFailed");
      } else {
        myList.addAll(result.data!.map((e) => e.id));
      }
      DataState<List<TvShowAndMovie>> resultPagination;
      int count = 10;
      while (true) {
        if (count == 0) {
          break;
        }
        count -= 1;
        resultPagination = await tvShowAndMovieRepository
            .loadMoreTvShowAndMovie(PaginationType.genrePage);
        if (resultPagination is DataFailed) {
          debugPrint("DataFailed");
          debugPrint(resultPagination.error!.item1.toString());
          debugPrint(resultPagination.error!.item2.toString());
        } else {
          if (resultPagination.data!.isEmpty) {
            debugPrint("Fim da lista");
            break;
          }
          myList.addAll(resultPagination.data!.map((e) => e.id));
        }
      }
      debugPrint(myList.toString());
      debugPrint(myList.length.toString());
      if (myList
          .where((string) =>
              myList.where((item) => item == string).toList().length > 1)
          .isNotEmpty) {
        debugPrint("há elementos repetidos na lista");
      } else {
        debugPrint("não há elementos repetidos na lista");
      }
    });
  });

  group('xtestando funcionalidades do sharedPrefs', () {
    test("testes no sistema de salvamento/obtenção de favoritos", () async {
      var ids = [
        "302017723",
        "299455137",
        "302378633",
        "301994016",
        "302201316"
      ];
      List<TvShowAndMovie?> tvShowAndMovieList = [];
      for (String id in ids) {
        var result = await tvShowAndMovieRepository.getTvShowAndMovie(id);
        if (result is DataSucess) {
          if (result.data == null) {
          } else {
            if (id.endsWith("3")) {
              result.data!.isFavorite == true;
              var res =
                  await tvShowAndMovieRepository.setTvSerieAndMoveWithFavorite(
                result.data!,
              );
              if (res is DataSucess) {
                debugPrint("$id ${res.data}");
              } else {
                debugPrint(res.error!.item1.toString());
                debugPrint(res.error!.item2.toString());
              }
            }
            tvShowAndMovieList.add(result.data);
          }
        } else {
          debugPrint("error get id $id");
        }
      }
      var resultDataOld =
          await tvShowAndMovieRepository.getAllTvShowAndMovieWithFavorite();
      if (resultDataOld is DataSucess) {
        debugPrint("get_old com sucesso");
        debugPrint(resultDataOld.data!.map((e) => e.id).toString());
      } else {
        debugPrint(resultDataOld.error.toString());
      }
      debugPrint(tvShowAndMovieList.length.toString());
      for (TvShowAndMovie? tvShowAndMovie in tvShowAndMovieList) {
        var res = await tvShowAndMovieRepository
            .setTvSerieAndMoveWithFavorite(tvShowAndMovie!);
        if (res is DataSucess) {
          debugPrint("${tvShowAndMovie.id} ${res.data}");
        } else {
          debugPrint(res.error!.item1.toString());
          debugPrint(res.error!.item2.toString());
        }
      }

      var resultDataNew =
          await tvShowAndMovieRepository.getAllTvShowAndMovieWithFavorite();
      if (resultDataNew is DataSucess) {
        debugPrint(resultDataNew.data!.map((e) => e.id).toString());
      } else {
        debugPrint(resultDataNew.error.toString());
      }
    });

    test("testando loadUserId", () async {
      var resultDeviceInfo = await tvShowAndMovieRepository.getUserId();
      debugPrint(resultDeviceInfo.toString());
      if (resultDeviceInfo.isLeft) {
        debugPrint("é left");
        debugPrint(resultDeviceInfo.left);
      } else {
        debugPrint(resultDeviceInfo.right.item1);
        debugPrint(resultDeviceInfo.right.item2.toString());
      }
    });
  });

  group('testando funcionalidades do sharedPrefs+firebase', () {
    test(
        "teste na atualização de visualização de séries/filmes em um único dispositivo",
        () async {
      var id = "302017723";
      int oldCount = -2;
      int newCount = -1;
      var result = await tvShowAndMovieRepository.getTvShowAndMovie(id);
      if (result is DataSucess) {
        if (result.data == null) {
          debugPrint("id no Exists");
        } else {
          debugPrint("idExists");

          debugPrint(result.data!.viewsCount.toString());
        }
      } else {
        debugPrint("error");
      }

      await tvShowAndMovieRepository.updateTvShowAndMovieViewViewCount(id);

      result = await tvShowAndMovieRepository.getTvShowAndMovie(id);
      if (result is DataSucess) {
        if (result.data == null) {
          debugPrint("id no Exists");
        } else {
          debugPrint("idExists");

          oldCount = result.data!.viewsCount;
          debugPrint(result.data!.viewsCount.toString());
        }
      } else {
        debugPrint("error");
      }
      await tvShowAndMovieRepository.updateTvShowAndMovieViewViewCount(id);

      result = await tvShowAndMovieRepository.getTvShowAndMovie(id);
      if (result is DataSucess) {
        if (result.data == null) {
          debugPrint("id no Exists");
        } else {
          debugPrint("idExists");
          newCount = result.data!.viewsCount;
        }
      } else {
        debugPrint("error");
      }

      if (oldCount == newCount) {
        debugPrint("teste sucesso");
      } else {
        debugPrint("teste falhou");
      }
    });

    test("testando updateUserHistory", () async {
      var res = await mockUserRepositoryImpl.loginViaGoogle();
      if (res is DataSucess) {
        print("foi login ${res.data}");
      } else {
        print("error login ${res.error!.item1}${res.error!.item2}");
      }
      var resultDeviceInfo = await tvShowAndMovieRepository.getUserId();
      debugPrint(resultDeviceInfo.toString());
      if (resultDeviceInfo.isLeft) {
        debugPrint("é left");
        debugPrint(resultDeviceInfo.left);
        var result = await mockUserRepositoryImpl
            ._loadUserHistory(resultDeviceInfo.left);
        if (result is DataSucess) {
          print(result.data.toString());
        } else {
          debugPrint(result.error!.item1);
          debugPrint(result.error!.item2.toString());
        }
      } else {
        debugPrint(resultDeviceInfo.right.item1);
        debugPrint(resultDeviceInfo.right.item2.toString());
      }
    });
    test("testando checkIntegrity", () async {
      //*Atualiza CheckUserHistory *//
      var res = await mockUserRepositoryImpl.loginViaGoogle();
      if (res is DataSucess) {
        print("foi login ${res.data}");
      } else {
        print("error login ${res.error!.item1}${res.error!.item2}");
      }
      var resultDeviceInfo = await tvShowAndMovieRepository.getUserId();
      debugPrint(resultDeviceInfo.toString());

      if (resultDeviceInfo.isLeft) {
        debugPrint("é left");
        debugPrint(resultDeviceInfo.left);
        var result = await mockUserRepositoryImpl
            ._loadUserHistory(resultDeviceInfo.left);
        if (result is DataSucess) {
          print(result.data.toString());
        } else {
          debugPrint(result.error!.item1);
          debugPrint(result.error!.item2.toString());
        }
      } else {
        debugPrint(resultDeviceInfo.right.item1);
        debugPrint(resultDeviceInfo.right.item2.toString());
      }
      //*Atualiza favorites*//
      var ids = [
        "302017723",
        "299455137",
        "302378633",
        "301994016",
        "302201316"
      ];
      List<TvShowAndMovie?> tvShowAndMovieList = [];
      for (String id in ids) {
        var result = await tvShowAndMovieRepository.getTvShowAndMovie(id);
        if (result is DataSucess) {
          if (result.data == null) {
          } else {
            if (id.endsWith("3")) {
              result.data!.isFavorite == true;
              var res =
                  await tvShowAndMovieRepository.setTvSerieAndMoveWithFavorite(
                result.data!,
              );
              if (res is DataSucess) {
                debugPrint("$id ${res.data}");
              } else {
                debugPrint(res.error!.item1.toString());
                debugPrint(res.error!.item2.toString());
              }
            }
            tvShowAndMovieList.add(result.data);
          }
        } else {
          debugPrint("error get id $id");
        }
      }
      //*Atualiza viewed*//
      var id = "302017723";
      int oldCount = -2;
      int newCount = -1;
      var result = await tvShowAndMovieRepository.getTvShowAndMovie(id);
      if (result is DataSucess) {
        if (result.data == null) {
          debugPrint("id no Exists");
        } else {
          debugPrint("idExists");

          debugPrint(result.data!.viewsCount.toString());
        }
      } else {
        debugPrint("error");
      }

      await tvShowAndMovieRepository.updateTvShowAndMovieViewViewCount(id);
      //*testando checkIntegrity *//
      await tvShowAndMovieRepository.changeData();

      await dataIntegrityCheckerRepositoryImpl.checkIntegrity();
    });
  });

  group('testando useCases', () {
    test("testando useCase GetAllTvShowAndMovieWithFavoriteUseCase", () async {
      MockGetAllTvShowAndMovieWithFavoriteUseCase(tvShowAndMovieRepository)();
    });
    test("testando useCase GetAllTvShowAndMovieUseCase", () async {
      DataState<List<Tuple2<String, List<TvShowAndMovie>>>> x =
          await MockGetAllTvShowAndMovieUseCase(tvShowAndMovieRepository)();
      if (x is DataSucess) {
        debugPrint(x.data.toString());
      }
    });
  });
  group('testando inject', () {
    test("testando useCase GetAllTvShowAndMovieUseCase", () async {
      await mockInitializeDependencies();
      MockGetAllTvShowAndMovieUseCase res =
          Get.find<MockGetAllTvShowAndMovieUseCase>();
      var result = await res();
      if (result is DataSucess) {
        debugPrint("foi useCase ${result.data}");
      } else {
        debugPrint(
            "nao foi useCase ${result.error!.item1} ${result.error!.item2}");
      }
      TvShowAndMovieRepository tvShowAndMovieRepository =
          Get.find<TvShowAndMovieRepository>();
      var result2 = await tvShowAndMovieRepository.getTvShowAndMovieByGenres(
          [GenreType.animation, GenreType.actionAdventure]);
      if (result2 is DataSucess) {
        debugPrint("foi repo ${result2.data!}");
      } else {
        debugPrint("nao foi repo ${result.error} ${result.error}");
      }
    });
    test("testando useCase LoginViaGoogleUseCase", () async {
      await mockInitializeDependencies();
      MockLoginViaGoogleUseCase res = Get.find<MockLoginViaGoogleUseCase>();
      var result = await res();
      if (result is DataSucess) {
        debugPrint("foi useCase ${result.data}");
      } else {
        debugPrint(
            "nao foi useCase ${result.error!.item1} ${result.error!.item2}");
      }
    });
    test("testando useCase LogOutUseCase", () async {
      await mockInitializeDependencies();
      MockLogOutUseCase res = Get.find<MockLogOutUseCase>();
      var result = await res();
      if (result is DataSucess) {
        debugPrint("foi useCase ${result.data}");
      } else {
        debugPrint(
            "nao foi useCase ${result.error!.item1} ${result.error!.item2}");
      }
    });
  });
  group('testando firebase Auth', () {
    test("testando loginViaGoogle", () async {
      var res = await mockUserRepositoryImpl.loginViaGoogle();
      if (res is DataSucess) {
        print("foi ${res.data}");
      } else {
        print("error ${res.error!.item1}${res.error!.item2}");
      }
    });
    test("testando logOut", () async {
      var res = await mockUserRepositoryImpl.logOut();
      if (res is DataSucess) {
        print("foi ${res.data}");
      } else {
        print("error ${res.error!.item1}${res.error!.item2}");
      }
    });
  });
}
