import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/data/datasource/auth/firebase_auth_handler_service.dart';
import 'package:tem_final/src/data/datasource/local/local_preferences_handler_service.dart';
import 'package:tem_final/src/data/datasource/remote/firebase_handler_service.dart';
import 'package:tem_final/src/data/mappers/tv_show_and_movie_mapper.dart';
import 'package:tem_final/src/data/mappers/user_history_mapper.dart';
import 'package:tem_final/src/data/repositories/data_integrity_checker_repository_impl.dart';
import 'package:tem_final/src/data/repositories/tv_show_and_movie_repository_impl.dart';
import 'package:tem_final/src/data/repositories/user_repository_impl.dart';
import 'package:tem_final/src/domain/repositories/data_integrity_checker_repository.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_move_with_favorite_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_local_user_history_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_by_genres_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_main_page_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_tv_show_and_movie_rating_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_user_history_rating_usecase.dart';
import 'package:tem_final/src/domain/usecases/search_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';
import 'package:tem_final/src/domain/usecases/set_tv_serie_and_movie_with_favorite_usecase.dart';
import 'package:tem_final/src/domain/usecases/submit_report_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_view_count_usecase.dart';

Future<void> initializeDependencies() async {
  FirebaseHandlerService firebaseHandlerService =
      Get.put(FirebaseHandlerService());

  FirebaseAuthHandlerService firebaseAuthHandlerService =
      Get.put(FirebaseAuthHandlerService());
  LocalPreferencesHandlerService localPreferencesHandlerService =
      Get.put(LocalPreferencesHandlerService());

  TvShowAndMovieMapper mapper = Get.put(TvShowAndMovieMapper());
  UserHistoryMapper userHistoryMapper = Get.put(UserHistoryMapper());

  await localPreferencesHandlerService.init();

  //var resultLocalUserId = await localPreferencesHandlerService.loadUserId();

  UserRepository userRepository = Get.put(UserRepositoryImpl(
    firebaseHandlerService: firebaseHandlerService,
    firebaseAuthHandlerService: firebaseAuthHandlerService,
    localPreferencesHandlerService: localPreferencesHandlerService,
    userHistoryMapper: userHistoryMapper,
  ));
  DataIntegrityChecker dataIntegrityChecker =
      Get.put(DataIntegrityCheckerRepositoryImpl(
    firebaseHandlerService: firebaseHandlerService,
    firebaseAuthHandlerService: firebaseAuthHandlerService,
    localPreferencesHandlerService: localPreferencesHandlerService,
    userRepository: userRepository,
  ));
  /**APENAS TESTE */
  //await userRepository.loginViaGoogle();

  await dataIntegrityChecker.checkIntegrity();

  await dataIntegrityChecker.checkMultiDeviceLoginStatus();

  String userId = "";
  var resultUserId = await userRepository.getUserId();
  if (resultUserId.isLeft) {
    userId = resultUserId.left;
  }
  print("userId $userId");

  /**APENAS TESTE */
  TvShowAndMovieRepository tvShowAndMovieRepository = Get.put(
      TvShowAndMovieRepositoryImpl(
          firebaseHandlerService: firebaseHandlerService,
          localPreferencesHandlerService: localPreferencesHandlerService,
          mapper: mapper,
          userHistoryMapper: userHistoryMapper,
          userId: userId));

  Get.put(GetAllTvShowAndMovieWithFavoriteUseCase(tvShowAndMovieRepository));
  Get.put(GetAllTvShowAndMovieUseCase(tvShowAndMovieRepository));
  Get.put(GetAllMovieUseCase(tvShowAndMovieRepository));
  Get.put(GetAllTvShowUseCase(tvShowAndMovieRepository));
  Get.put(GetTvShowAndMovieByGenresUseCase(tvShowAndMovieRepository));
  Get.put(GetTvShowAndMovieUseCase(tvShowAndMovieRepository));
  Get.put(LoadMoreTvShowAndMovieUseCase(tvShowAndMovieRepository));
  Get.put(LoadMoreTvShowAndMovieMainPageUseCase(tvShowAndMovieRepository));
  Get.put(SearchTvShowAndMovieUseCase(tvShowAndMovieRepository));
  Get.put(SelectConclusionUseCase(tvShowAndMovieRepository));
  Get.put(SetTvSerieAndMovieWithFavoriteUseCase(tvShowAndMovieRepository));
  Get.put(UpdateTvShowAndMovieViewCountUseCase(tvShowAndMovieRepository));
  Get.put(UpdateTvShowAndMovieRatingUseCase(tvShowAndMovieRepository));
  Get.put(UpdateUserHistoryRatingUseCase(tvShowAndMovieRepository));
  print("Oi");
  Get.put(SubmitReportUseCase(userRepository));
  Get.put(LoginViaGoogleUseCase(userRepository));
  Get.put(LogOutUseCase(userRepository));
  Get.put(GetLocalUserHistoryUseCase(userRepository));
}
