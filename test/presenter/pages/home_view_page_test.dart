import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/presenter/controllers/tv_shows_and_movies_controller.dart';
import 'package:tem_final/src/presenter/reusableWidgets/error_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/tiles/tv_show_and_movie_tile.dart';
import 'package:tuple/tuple.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

import '../controllers/tv_shows_and_movies_controller.dart';

class MockHomeViewPage extends StatelessWidget {
  MockHomeViewPage({super.key});
  final MockTvShowsAndMoviesController tvShowAndMovieController =
      Get.find<MockTvShowsAndMoviesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0.0,
        title: Image.asset(
          "assets/logo.png",
          fit: BoxFit.cover,
          height: 35,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: colorSearch,
              ))
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _customOutlineButton(
                    onPressed: () {
                      tvShowAndMovieController.getAllTvShowAndMovie();
                    },
                    text: Filter.all.string,
                    selectedText:
                        tvShowAndMovieController.filterSelected.value),
                _customOutlineButton(
                  onPressed: () {
                    tvShowAndMovieController.getAllMovie();
                  },
                  text: Filter.movie.string,
                  selectedText: tvShowAndMovieController.filterSelected.value,
                ),
                _customOutlineButton(
                  onPressed: () {
                    tvShowAndMovieController.getAllTvShow();
                  },
                  text: Filter.tvShow.string,
                  selectedText: tvShowAndMovieController.filterSelected.value,
                ),
              ],
            );
          }),
          Obx(() {
            switch (
                tvShowAndMovieController.statusLoadingTvSHowAndMovie.value) {
              case StatusLoadingTvShowAndMovie.firstRun:
                tvShowAndMovieController.getAllTvShowAndMovie();
                return Container();
              case StatusLoadingTvShowAndMovie.loading:
                return const Expanded(
                  child: CustomLoadingWidget(),
                );
              case StatusLoadingTvShowAndMovie.error:
                CustomToast(
                    msg:
                        tvShowAndMovieController.errorListTvShowAndMovie.value);
                return Container();

              case StatusLoadingTvShowAndMovie.sucess:
                return _buildListTvShowAndMovie(
                    tvShowAndMovieController.listTvShowAndMovie);
            }
          })
        ],
      ),
      bottomNavigationBar: Obx(() {
        return FloatingNavbar(
          onTap: tvShowAndMovieController.updateIndexSelected,
          backgroundColor: appBarColor,
          currentIndex: tvShowAndMovieController.indexSelected.value,
          unselectedItemColor: optionFilledColor,
          selectedItemColor: textColorFilledOption,
          selectedBackgroundColor: optionFilledColor,
          items: [
            FloatingNavbarItem(icon: Icons.home, title: 'Início'),
            FloatingNavbarItem(icon: Icons.favorite, title: 'Favoritos'),
            FloatingNavbarItem(icon: Icons.settings, title: 'Configurações'),
          ],
        );
      }),
    );
  }
}

_customOutlineButton(
    {required void Function()? onPressed,
    required text,
    required selectedText}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: text == selectedText
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: optionFilledColor, //<-- SEE HERE
            ),
            child: Text(
              text,
              style: const TextStyle(
                  fontFamily: fontFamily,
                  color: textColorFilledOption,
                  fontSize: 16),
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(
                  fontFamily: fontFamily,
                  color: optionFilledColor,
                  fontSize: 16),
            )),
  );
}

Expanded _buildListTvShowAndMovie(
    List<Tuple2<String, List<TvShowAndMovie>>> listTvShowAndMovie) {
  return Expanded(
    child: ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
          itemCount: listTvShowAndMovie.length,
          itemBuilder: (ctx, index) {
            if (listTvShowAndMovie[index].item1.isNotEmpty) {
              Tuple2<String, List<TvShowAndMovie>> tuple =
                  listTvShowAndMovie[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: SizedBox(
                  height: WidgetSize.sizeSectionGenre,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          12.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                tuple.item1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: fontFamily,
                                    color: textColorGenreMainPage,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: textColorGenreMainPage,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: tuple.item2
                              .map((item) => GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.info, arguments: {
                                        "idTvShowAndMovie": item.id,
                                        "titleTvShowAndMovie": item.title
                                      });
                                    },
                                    child: TvShowAndMovieTile(
                                      tvShowAndMovie: item,
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Container();
          }),
    ),
  );
}
