import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:tem_final/src/domain/usecases/filter_genres_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_move_with_favorite_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_local_user_history_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_recents_tv_show_and_movie_viewed.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_by_genres_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_username_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_main_page_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';
import 'package:tem_final/src/domain/usecases/remove_user_usecase.dart';
import 'package:tem_final/src/domain/usecases/set_recents_tv_show_and_movie_viewed.dart';
import 'package:tem_final/src/domain/usecases/update_rating_usecase.dart';
import 'package:tem_final/src/domain/usecases/search_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';
import 'package:tem_final/src/domain/usecases/set_tv_serie_and_movie_with_favorite_usecase.dart';
import 'package:tem_final/src/domain/usecases/submit_report_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_view_count_usecase.dart';
import 'package:tem_final/src/domain/usecases/verifiy_user_is_logged_usecase.dart';

Future<String> initializeDependencies(
  LocalPreferencesHandlerService localPreferencesHandlerService,
  DataIntegrityChecker dataIntegrityChecker,
  UserRepository userRepository,
) async {
  try {
    await localPreferencesHandlerService.init();
    await dataIntegrityChecker.checkIntegrity();
    await dataIntegrityChecker.checkMultiDeviceLoginStatus();
    if (await dataIntegrityChecker.checkUserIsLoggedOtherDevice()) {
      await userRepository.logOut();
    }
    String userId = "";
    var resultUserId = await userRepository.getUserId();
    debugPrint(resultUserId.toString());
    if (resultUserId.isLeft) {
      userId = resultUserId.left;
    }
    await localPreferencesHandlerService.setUserId(userId);
    return userId;
  } catch (e) {
    return "";
  }
}

class ProviderInjection extends StatelessWidget {
  const ProviderInjection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers da camada de dados
        Provider<FirebaseAuthHandlerService>(
          create: (_) => FirebaseAuthHandlerService(),
        ),
        Provider<FirebaseHandlerService>(
          create: (_) => FirebaseHandlerService(),
        ),
        Provider<TvShowAndMovieMapper>(
          create: (context) => TvShowAndMovieMapper(),
        ),
        Provider<LocalPreferencesHandlerService>(
          create: (context) {
            return LocalPreferencesHandlerService();
          },
        ),
        Provider<UserHistoryMapper>(
          create: (context) => UserHistoryMapper(),
        ),
        Provider<UserRepository>(
          create: (context) {
            return UserRepositoryImpl(
              firebaseAuthHandlerService:
                  context.read<FirebaseAuthHandlerService>(),
              firebaseHandlerService: context.read<FirebaseHandlerService>(),
              localPreferencesHandlerService:
                  context.read<LocalPreferencesHandlerService>(),
              userHistoryMapper: context.read<UserHistoryMapper>(),
            );
          },
        ),
        Provider<DataIntegrityChecker>(
          create: (context) {
            return DataIntegrityCheckerRepositoryImpl(
              firebaseAuthHandlerService:
                  context.read<FirebaseAuthHandlerService>(),
              firebaseHandlerService: context.read<FirebaseHandlerService>(),
              localPreferencesHandlerService:
                  context.read<LocalPreferencesHandlerService>(),
              userRepository: context.read<UserRepository>(),
            );
          },
        ),

        Provider<SubmitReportUseCase>(
            create: (context) =>
                SubmitReportUseCase(context.read<UserRepository>())),
        Provider<LoginViaGoogleUseCase>(
            create: (context) =>
                LoginViaGoogleUseCase(context.read<UserRepository>())),
        Provider<LogOutUseCase>(
            create: (context) => LogOutUseCase(context.read<UserRepository>())),
        Provider<GetLocalUserHistoryUseCase>(
            create: (context) =>
                GetLocalUserHistoryUseCase(context.read<UserRepository>())),
        Provider<VerifiyUserIsLoggedUseCase>(
            create: (context) =>
                VerifiyUserIsLoggedUseCase(context.read<UserRepository>())),
        Provider<GetUsernameUseCase>(
            create: (context) =>
                GetUsernameUseCase(context.read<UserRepository>())),
        /*Provider<RemoveUserUseCase>(
            create: (context) =>
                RemoveUserUseCase(context.read<UserRepository>())),*/
      ],
      child: Builder(builder: (context) {
        return FutureBuilder(
            future: initializeDependencies(
                context.read<LocalPreferencesHandlerService>(),
                context.read<DataIntegrityChecker>(),
                context.read<UserRepository>()),
            builder: (ctx, snp) {
              if (snp.connectionState == ConnectionState.done) {
                return MultiProvider(providers: [
                  Provider<TvShowAndMovieRepository>(
                    create: (context) => TvShowAndMovieRepositoryImpl(
                        mapper: context.read<TvShowAndMovieMapper>(),
                        firebaseHandlerService:
                            context.read<FirebaseHandlerService>(),
                        localPreferencesHandlerService:
                            context.read<LocalPreferencesHandlerService>(),
                        userHistoryMapper: context.read<UserHistoryMapper>(),
                        userRepository: context.read<UserRepository>()),
                  ),
                  Provider<GetAllTvShowAndMovieWithFavoriteUseCase>(
                      create: (context) =>
                          GetAllTvShowAndMovieWithFavoriteUseCase(
                              context.read<TvShowAndMovieRepository>())),
                  Provider<GetAllTvShowAndMovieUseCase>(
                      create: (context) => GetAllTvShowAndMovieUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<GetAllMovieUseCase>(
                      create: (context) => GetAllMovieUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<GetAllTvShowUseCase>(
                      create: (context) => GetAllTvShowUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<GetTvShowAndMovieByGenresUseCase>(
                      create: (context) => GetTvShowAndMovieByGenresUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<GetTvShowAndMovieUseCase>(
                      create: (context) => GetTvShowAndMovieUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<LoadMoreTvShowAndMovieGenrePageUseCase>(
                      create: (context) =>
                          LoadMoreTvShowAndMovieGenrePageUseCase(
                              context.read<TvShowAndMovieRepository>())),
                  Provider<LoadMoreTvShowAndMovieMainPageUseCase>(
                      create: (context) =>
                          LoadMoreTvShowAndMovieMainPageUseCase(
                              context.read<TvShowAndMovieRepository>())),
                  Provider<SearchTvShowAndMovieUseCase>(
                      create: (context) => SearchTvShowAndMovieUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<SelectConclusionUseCase>(
                      create: (context) => SelectConclusionUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<SetTvSerieAndMovieWithFavoriteUseCase>(
                      create: (context) =>
                          SetTvSerieAndMovieWithFavoriteUseCase(
                              context.read<TvShowAndMovieRepository>())),
                  Provider<UpdateTvShowAndMovieViewCountUseCase>(
                      create: (context) => UpdateTvShowAndMovieViewCountUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<UpdateRatingUseCase>(
                      create: (context) => UpdateRatingUseCase(
                          context.read<TvShowAndMovieRepository>())),
                  Provider<SetRecentsTvShowAndMovieViewedUseCase>(
                      create: (context) =>
                          SetRecentsTvShowAndMovieViewedUseCase(
                              context.read<TvShowAndMovieRepository>())),
                  Provider<GetRecentsTvShowAndMovieViewedUseCase>(
                      create: (context) =>
                          GetRecentsTvShowAndMovieViewedUseCase(
                              context.read<TvShowAndMovieRepository>())),
                  Provider<FilterGenresUseCase>(
                      create: (context) => FilterGenresUseCase(
                          context.read<TvShowAndMovieRepository>())),
                ], child: child);
              }
              {
                return const SizedBox();
              }
            });
      }),
    );
  }
}
