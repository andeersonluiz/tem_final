import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/presenter/pages/genre/genre_page.dart';
import 'package:tem_final/src/presenter/pages/home/main_page.dart';
import 'package:tem_final/src/presenter/pages/privacyPolicy/privacy_policy_page.dart';
import 'package:tem_final/src/presenter/pages/termsAndConditions/terms_and_conditions_page.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/tv_show_and_movie_info_page.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainPage(),
        );

      case Routes.info:
        return PageRouteBuilder(
            transitionsBuilder: myTrasition,
            pageBuilder: (_, __, ___) {
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
      case Routes.privacyPolicy:
        return PageRouteBuilder(
            transitionsBuilder: myTrasition,
            pageBuilder: (_, __, ___) => const PrivacyPolicyPage());
      case Routes.termsAndConditions:
        return PageRouteBuilder(
            transitionsBuilder: myTrasition,
            pageBuilder: (_, __, ___) => const TermsAndConditionsPage());
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
