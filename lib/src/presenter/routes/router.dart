import 'package:go_router/go_router.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/presenter/pages/home_view_page.dart';
import 'package:tem_final/src/presenter/pages/tv_show_and_movie_info_page.dart';

class MyRouter {
  static final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomeViewPage(),
    ),
    GoRoute(
      path: "${Routes.info}/:title/:idTvShowAndMovie",
      name: Routes.info,
      builder: (context, state) {
        return TvShowAndMovieInfoPage(
            idTvShowAndMovie: state.params["idTvShowAndMovie"]!,
            titleTvShowAndMovie: state.params["title"]!);
      },
    ),
  ]);
}
