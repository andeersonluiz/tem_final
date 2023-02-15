import 'package:get/get.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/presenter/bindings/analytics_binding.dart';
import 'package:tem_final/src/presenter/bindings/conclusion_binding.dart';
import 'package:tem_final/src/presenter/bindings/favorite_binding.dart';
import 'package:tem_final/src/presenter/bindings/feedback_binding.dart';
import 'package:tem_final/src/presenter/bindings/rating_bindind.dart';
import 'package:tem_final/src/presenter/bindings/tv_show_and_movie_binding.dart';
import 'package:tem_final/src/presenter/bindings/tv_shows_and_movies_binding.dart';
import 'package:tem_final/src/presenter/bindings/user_history_binding.dart';
import 'package:tem_final/src/presenter/pages/home_view_page.dart';
import 'package:tem_final/src/presenter/pages/tv_show_and_movie_info_page.dart';

class MyRouter {
  static final routes = [
    GetPage(
        name: Routes.home,
        page: () => HomeViewPage(),
        binding: TvShowsAndMoviesBinding()),
    GetPage(
      name: Routes.info,
      page: () => TvShowAndMovieInfoPage(),
      bindings: [
        ConclusionBinding(),
        FavoriteBinding(),
        FeedbackBinding(),
        AnalyticsBinding(),
        TvShowAndMovieBinding(),
        UserHistoryBinding(),
        RatingBinding(),
      ],
    ),
  ];
}
