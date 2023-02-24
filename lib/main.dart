import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, SystemUiOverlay, rootBundle;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_move_with_favorite_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_recents_tv_show_and_movie_viewed.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_main_page_usecase.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';
import 'package:tem_final/src/domain/usecases/set_recents_tv_show_and_movie_viewed.dart';
import 'package:tem_final/src/domain/usecases/set_tv_serie_and_movie_with_favorite_usecase.dart';
import 'package:tem_final/src/injection.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_bloc.dart';
import 'package:tem_final/src/presenter/routes/router.dart';
import 'package:tem_final/src/presenter/stateManagement/valueNoifier/local_rating_notifier.dart';

import 'src/domain/usecases/get_all_movie_usecase.dart';
import 'src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'src/domain/usecases/get_all_tv_show_usecase.dart';
import 'src/domain/usecases/search_tv_show_and_movie_usecase.dart';
import 'src/domain/usecases/update_rating_usecase.dart';
import 'src/domain/usecases/verifiy_user_is_logged_usecase.dart';
import 'src/presenter/stateManagement/bloc/conclusion/conclusion_bloc.dart';
import 'src/presenter/stateManagement/bloc/search/search_bloc.dart';
import 'src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_bloc.dart';
import 'package:provider/provider.dart';

import 'src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await supabase.Supabase.initialize(
    url: "https://imqmttavuchgrverzvee.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImltcW10dGF2dWNoZ3J2ZXJ6dmVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzYyNDY2ODgsImV4cCI6MTk5MTgyMjY4OH0.hl6Rw7phI4wwaeEEk4LJB3SMnEOn1XcjTBnu-PQQ4ko",
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  /*var file = await rootBundle.loadString('assets/dataUpdated.json');
  var result = jsonDecode(file);
  supabase.SupabaseClient client = supabase.Supabase.instance.client;
  for (var item in result) {
    try {
      print("addd");
      await client.from(kDocumentTvShowAndMovies).upsert(item);
    } catch (e) {
      print("${item["id"]} repetido");
    }
  }*/
/*
  var x = await supabase
      .from(kDocumentTvShowAndMovies)
      .select()
      .eq("id", "140225063");

  for (GenreType genre in GenreType.values) {
    var genreArray = [genre.string];
    var queryDocumentData = (await supabase
        .from("tvShowAndMovies")
        .select()
        .containedBy("genres", ["Drama", "História"]));

    print(queryDocumentData.runtimeType);
    print(queryDocumentData.length);
    print(queryDocumentData.first);
    List<Map<String, dynamic>> maps = queryDocumentData
        .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
        .toList();
    for (var item in maps) {
      print(item["genres"]);
    }
    break;
  }
*/
  runApp(ProviderInjection(
    child: MultiProvider(
      providers: [
        Provider<TvShowAndMovieBloc>(
            create: (context) => TvShowAndMovieBloc(
                  context.read<GetAllTvShowAndMovieUseCase>(),
                  context.read<GetAllMovieUseCase>(),
                  context.read<GetAllTvShowUseCase>(),
                  context.read<LoadMoreTvShowAndMovieMainPageUseCase>(),
                )),
        Provider<TvShowAndMovieInfoBloc>(
          create: (context) =>
              TvShowAndMovieInfoBloc(context.read<GetTvShowAndMovieUseCase>()),
        ),
        Provider<RatingBloc>(
            create: (context) => RatingBloc(context.read<UpdateRatingUseCase>(),
                context.read<VerifitUserIsLoggedUseCase>())),
        Provider<ConclusionBloc>(
            create: (context) => ConclusionBloc(
                context.read<SelectConclusionUseCase>(),
                context.read<VerifitUserIsLoggedUseCase>())),
        Provider<SearchBloc>(
            create: (context) => SearchBloc(
                  context.read<SearchTvShowAndMovieUseCase>(),
                  context.read<SetRecentsTvShowAndMovieViewedUseCase>(),
                  context.read<GetRecentsTvShowAndMovieViewedUseCase>(),
                )),
        Provider<FavoriteBloc>(
            create: (context) => FavoriteBloc(
                  context.read<GetAllTvShowAndMovieWithFavoriteUseCase>(),
                  context.read<SetTvSerieAndMovieWithFavoriteUseCase>(),
                )),
        Provider<LocalRatingNotifier>(
            create: (context) => LocalRatingNotifier()),
      ],
      child: Builder(builder: (context) {
        return ResponsiveSizer(builder: (ctx, orientation, screenType) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: MyRouter.router,
          );
        });
      }),
    ),
  ));
}
