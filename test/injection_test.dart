import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/data/mappers/tv_show_and_movie_mapper.dart';
import 'package:tem_final/src/data/mappers/user_history_mapper.dart';
import 'package:tem_final/src/domain/repositories/data_integrity_checker_repository.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';
import 'package:tem_final/src/domain/usecases/get_local_user_history_usecase.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';

import 'domain/usecases/get_all_movie_usecase_test.dart';
import 'domain/usecases/get_all_tv_show_and_move_with_favorite_usecase_test.dart';
import 'domain/usecases/get_all_tv_show_and_movie_usecase_test.dart';
import 'domain/usecases/get_all_tv_show_usecase_test.dart';
import 'domain/usecases/get_local_user_history_usecase.dart';
import 'domain/usecases/get_tv_show_and_movie_by_genres_usecase_test.dart';
import 'domain/usecases/get_tv_show_and_movie_usecase_test.dart';
import 'domain/usecases/load_more_tv_show_and_movie_usecase_test.dart';
import 'domain/usecases/log_out_usecase_test.dart';
import 'domain/usecases/login_via_google_usecase_test.dart';
import 'domain/usecases/rating_tv_show_and_movie_usecase.dart';
import 'domain/usecases/search_tv_show_and_movie_usecase_test.dart';
import 'domain/usecases/set_tv_serie_and_movie_with_favorite_usecase_test.dart';
import 'domain/usecases/submit_report_usecase_test.dart';
import 'domain/usecases/update_view_count_usecase_test.dart';
import 'data/datasource/auth/firebase_auth_handler_service_test.dart';
import 'data/datasource/local/local_preferences_handler_service_test.dart';
import 'data/datasource/remote/firebase_handler_service_test.dart';
import 'data/repositories/tv_show_and_movie_repository_test.dart';

Future<void> mockInitializeDependencies() async {
  MockFirebaseHandlerService firebaseHandlerService =
      Get.put(MockFirebaseHandlerService());
  await firebaseHandlerService.init();
  MockFirebaseAuthHandlerService firebaseAuthHandlerService =
      Get.put(MockFirebaseAuthHandlerService());
  MockLocalPreferencesHandlerService localPreferencesHandlerService =
      Get.put(MockLocalPreferencesHandlerService());

  TvShowAndMovieMapper mapper = Get.put(TvShowAndMovieMapper());
  UserHistoryMapper userHistoryMapper = Get.put(UserHistoryMapper());

  await localPreferencesHandlerService.init();

  UserRepository userRepository = Get.put(MockUserRepositoryImpl(
    firebaseHandlerService: firebaseHandlerService,
    firebaseAuthHandlerService: firebaseAuthHandlerService,
    localPreferencesHandlerService: localPreferencesHandlerService,
    userHistoryMapper: userHistoryMapper,
  ));

  DataIntegrityChecker dataIntegrityChecker =
      Get.put(MockDataIntegrityCheckerRepositoryImpl(
    firebaseHandlerService: firebaseHandlerService,
    firebaseAuthHandlerService: firebaseAuthHandlerService,
    localPreferencesHandlerService: localPreferencesHandlerService,
    userRepository: userRepository,
  ));
  userRepository.loginViaGoogle();

  await dataIntegrityChecker.checkIntegrity();
  await dataIntegrityChecker.checkMultiDeviceLoginStatus();
  String userId = "";
  var resultUserId = await userRepository.getUserId();
  if (resultUserId.isLeft) {
    userId = resultUserId.left;
  }
  TvShowAndMovieRepository tvShowAndMovieRepository = Get.put(
      MockTvShowAndMovieRepositoryImpl(
          firebaseHandlerService: firebaseHandlerService,
          localPreferencesHandlerService: localPreferencesHandlerService,
          mapper: mapper,
          userId: userId,
          firebaseAuthHandlerService: firebaseAuthHandlerService,
          userHistoryMapper: userHistoryMapper));

  Get.put(
      MockGetAllTvShowAndMovieWithFavoriteUseCase(tvShowAndMovieRepository));
  Get.put(MockGetAllTvShowAndMovieUseCase(tvShowAndMovieRepository));
  Get.put(MockGetAllMovieUseCase(tvShowAndMovieRepository));
  Get.put(MockGetAllTvShowUseCase(tvShowAndMovieRepository));
  Get.put(MockGetTvShowAndMovieByGenresUseCase(tvShowAndMovieRepository));
  Get.put(MockGetTvShowAndMovieUseCase(tvShowAndMovieRepository));
  Get.put(MockLoadMoreTvShowAndMovieUseCase(tvShowAndMovieRepository));
  Get.put(MockSearchTvShowAndMovieUseCase(tvShowAndMovieRepository));
  Get.put(SelectConclusionUseCase(tvShowAndMovieRepository));
  Get.put(MockSetTvSerieAndMovieWithFavoriteUseCase(tvShowAndMovieRepository));
  Get.put(MockupdateTvShowAndMovieViewCountUseCase(tvShowAndMovieRepository));
  Get.put(MockRatingTvShowAndMovieUseCase(tvShowAndMovieRepository));

  Get.put(MockSubmitReportUseCase(userRepository));
  Get.put(MockLoginViaGoogleUseCase(userRepository));
  Get.put(MockLogOutUseCase(userRepository));
  Get.put(MockGetLocalUserHistoryUseCase(userRepository));
}
