import 'package:get/get.dart';

import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/presenter/bindings/tv_shows_and_movies_binding.dart';
import 'package:tem_final/src/presenter/pages/home/home_view_page.dart';

import '../bindings/analytics_binding.dart';
import '../bindings/conclusion_binding.dart';
import '../bindings/favorite_binding.dart';
import '../bindings/feedback_binding.dart';
import '../bindings/tv_show_and_movie_binding.dart';
import '../bindings/tv_shows_and_movies_binding.dart';
import '../bindings/user_history_binding.dart';
import '../pages/home_view_page_test.dart';
import '../pages/tv_show_and_movie_info_page.dart';

class MockMyRouter {
  static final routes = [
    GetPage(
        name: Routes.home,
        page: () => MockHomeViewPage(),
        binding: MockTvShowsAndMoviesBinding()),
    GetPage(
      name: Routes.info,
      page: () => MockTvShowAndMovieInfoPage(),
      bindings: [
        MockConclusionBinding(),
        MockFavoriteBinding(),
        MockFeedbackBinding(),
        MockAnalyticsBinding(),
        MockTvShowAndMovieBinding(),
        MockUserHistoryBinding(),
      ],
    ),
  ];
}
