import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/presenter/pages/favorite/favorite_page.dart';
import 'package:tem_final/src/presenter/pages/genre/genre_page.dart';
import 'package:tem_final/src/presenter/pages/home/home_view_page.dart';
import 'package:tem_final/src/presenter/pages/home/main_page.dart';
import 'package:tem_final/src/presenter/pages/search/search_page.dart';
import 'package:tem_final/src/presenter/pages/settings/settings_page.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/tv_show_and_movie_info_page.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => MainPage(),
          transitionDuration: Duration(milliseconds: 5000),
        );

      case Routes.info:
        return PageRouteBuilder(pageBuilder: (_, __, ___) {
          var args = settings.arguments as Map<String, dynamic>;
          return TvShowAndMovieInfoPage(
              idTvShowAndMovie: args["idTvShowAndMovie"],
              titleTvShowAndMovie: args["title"]);
        });
      case Routes.genre:
        return PageRouteBuilder(
            transitionsBuilder: myTrasition,
            pageBuilder: (_, __, ___) {
              var args = settings.arguments as Map<String, dynamic>;
              return GenrePage(indexGenre: int.parse(args["index"]));
            });
      default:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

Widget myTrasition(BuildContext context, Animation<double> animation,
    Animation<double> secAnimation, child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}
