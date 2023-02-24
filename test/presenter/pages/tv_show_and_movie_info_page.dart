import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tem_final/src/core/resources/custom_icons.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';

import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../controllers/tv_show_and_movie_controller.dart';
import '../controllers/user_history_controller.dart';

class MockTvShowAndMovieInfoPage extends StatelessWidget {
  MockTvShowAndMovieInfoPage({super.key});

  final args = Get.arguments;

  final MockTvShowAndMovieController tvShowAndMovieController =
      Get.find<MockTvShowAndMovieController>();
  MockUserHistoryController userHistoryController =
      Get.find<MockUserHistoryController>();
  @override
  Widget build(BuildContext context) {
    final String idTvShowAndMovie = args["idTvShowAndMovie"];
    final String titleTvShowAndMovie = args["titleTvShowAndMovie"];
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0.0,
          title: AutoSizeText(titleTvShowAndMovie,
              minFontSize: 17,
              maxFontSize: 20,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: fontFamily)),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border))
          ],
        ),
        body: Obx(() {
          print("chei obx");
          print(tvShowAndMovieController.statusLoadingOnlyTvShowAndMovie.value);
          switch (
              tvShowAndMovieController.statusLoadingOnlyTvShowAndMovie.value) {
            case StatusLoadingOnlyTvShowAndMovie.firstRun:
              tvShowAndMovieController.getTvShowAndMovie(idTvShowAndMovie);
              return Container();
            case StatusLoadingOnlyTvShowAndMovie.loading:
              print("oi");
              return Column(
                children: [
                  Expanded(
                    child: Center(child: CustomLoadingWidget()),
                  ),
                ],
              );
            case StatusLoadingOnlyTvShowAndMovie.error:
              CustomToast(
                  msg: tvShowAndMovieController.errorTvShowAndMovie.value);
              return Container();
            case StatusLoadingOnlyTvShowAndMovie.sucess:
              final TvShowAndMovie? tvShowAndMovie =
                  tvShowAndMovieController.tvShowAndMovie.value;
              print(
                  tvShowAndMovie!.listTvShowAndMovieInfoStatusBySeason.length);
              return Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: tvShowAndMovie
                              .listTvShowAndMovieInfoStatusBySeason.length ==
                          1
                      ? Container(
                          height: WidgetSize.heightPosterInfoPageOneSeason,
                          child: Center(
                            child: _posterInfo(
                                tvShowAndMovie
                                    .listTvShowAndMovieInfoStatusBySeason.first,
                                tvShowAndMovie
                                    .listTvShowAndMovieInfoStatusBySeason
                                    .first
                                    .seasonNumber,
                                0),
                          ),
                        )
                      : CarouselSlider(
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              viewportFraction: 0.55,
                              aspectRatio: 1.4 * 1.3),
                          items: tvShowAndMovie
                              .listTvShowAndMovieInfoStatusBySeason
                              .asMap()
                              .entries
                              .map((item) {
                            TvShowAndMovieInfoStatus tvShowAndMovieInfoStatus =
                                item.value;
                            int index = item.key;

                            return _posterInfo(tvShowAndMovieInfoStatus,
                                tvShowAndMovieInfoStatus.seasonNumber, index);
                          }).toList()),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Theme(
                              data: ThemeData(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                              child: const TabBar(
                                  splashFactory: NoSplash.splashFactory,
                                  labelStyle: TextStyle(
                                      fontFamily: fontFamily, fontSize: 17),
                                  indicatorColor: indicatorColor,
                                  tabs: [
                                    Tab(
                                      text: "Tem final?",
                                    ),
                                    Tab(
                                      text: "Informações",
                                    ),
                                  ]),
                            ),
                            Expanded(
                                child: TabBarView(
                              children: [
                                Container(height: 50, child: Text("oi")),
                                _infoWidget(context),
                              ],
                            ))
                          ],
                        )),
                  ),
                )
              ]);
          }
        }));
  }

  Column _posterInfo(TvShowAndMovieInfoStatus tvShowAndMovieStatus,
      int seasonNumber, int index) {
    return Column(
      children: [
        Container(
          width: WidgetSize.widthPosterInfoPage,
          height: WidgetSize.heightPosterInfoPage,
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 400),
              fit: BoxFit.cover,
              width: WidgetSize.widthPosterInfoPage,
              height: WidgetSize.heightPosterInfoPage,
              imageUrl: tvShowAndMovieStatus.posterImageUrl,
              placeholder: (context, url) => Image.asset(
                    "assets/placeholderImage.gif",
                    fit: BoxFit.fill,
                  ) // Your default image here
              ),
        ),
        Flexible(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Temporada $seasonNumber",
                style: const TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColorGenreMainPage),
              ),
            ),
          ),
        )
      ],
    );
  }

  _infoWidget(BuildContext context) {
    final TvShowAndMovie tvShowAndMovie =
        tvShowAndMovieController.tvShowAndMovie.value!;
    final TextStyle textStyle =
        TextStyle(fontFamily: fontFamily, color: textColorFilledOption);
    print(tvShowAndMovie.ageClassification);
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: ratingColorPosterMainPage,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tvShowAndMovie.ageClassification.isNotEmpty
                      ? Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Classificação",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: textStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: _generateIconAgeClassification(
                                    tvShowAndMovie.ageClassification),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Imdb",
                            style: textStyle.copyWith(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              tvShowAndMovie.imdbInfo.rating == -1
                                  ? "-"
                                  : "${tvShowAndMovie.imdbInfo.rating}/10",
                              style: textStyle.copyWith(fontSize: 20)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                              "(Atualizado em: ${DateFormat("DD/MM/yyyy").format(tvShowAndMovie.imdbInfo.lastUpdate)})",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: textStyle.copyWith(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Temporadas",
                            style: textStyle.copyWith(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("${tvShowAndMovie.seasons.toString()}",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: textStyle.copyWith(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: ratingColorPosterMainPage,
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Minha avaliação: ",
                        style: textStyle.copyWith(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    tvShowAndMovie.isRated
                        ? Padding(
                            padding: EdgeInsets.all(10.0),
                            child: RatingBarIndicator(
                              rating: tvShowAndMovie.averageRating,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              unratedColor: unratedColorPosterMainPage,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: ratingColorPosterMainPage,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              _showModalBottomSheet(context, tvShowAndMovie);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor:
                                  ratingColorPosterMainPage, //<-- SEE HERE
                            ),
                            child: Text(
                              "Avalie ${tvShowAndMovie.seasons == -1 ? "o filme" : "a série"} ",
                              style: const TextStyle(
                                  fontFamily: fontFamily,
                                  color: textColorFilledOption,
                                  fontSize: 16),
                            ),
                          )
                  ],
                ),
              ),
            ),
            Divider(
              color: ratingColorPosterMainPage,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Sinopse",
                  style: textStyle.copyWith(
                      fontSize: 20,
                      color: ratingColorPosterMainPage,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(tvShowAndMovie.synopsis,
                  style: textStyle.copyWith(fontSize: 15)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Gêneros",
                  style: textStyle.copyWith(
                      fontSize: 20,
                      color: ratingColorPosterMainPage,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Wrap(
                  children: tvShowAndMovie.genres
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, top: 8.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ratingColorPosterMainPage,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  e,
                                  style: textStyle.copyWith(fontSize: 15),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }

  _showModalBottomSheet(BuildContext context, TvShowAndMovie tvShowAndMovie) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        backgroundColor: optionFilledColor,
        builder: (context) {
          return Container(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text("Sua Avaliação",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: textColorFilledOption,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                Builder(builder: (context) {
                  return RatingBar.builder(
                    onRatingUpdate: (rating) {
                      userHistoryController.updateRatingValue(
                          tvShowAndMovie.id, rating);
                    },
                    minRating: 1.0,
                    initialRating: userHistoryController.ratingValue.value,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 45,
                    glowColor: Colors.transparent,
                    itemPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    unratedColor: unratedColorPosterMainPage,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  );
                }),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      userHistoryController.ratingTvShowAndMovie();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: ratingColorPosterMainPage, //<-- SEE HERE
                    ),
                    child: Text(
                      "Envia avaliação",
                      style: const TextStyle(
                          fontFamily: fontFamily,
                          color: textColorFilledOption,
                          fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  _generateIconAgeClassification(String ageClassification) {
    switch (ageClassification) {
      case "L":
        return CustomIcons.L;
      case "10":
        return CustomIcons.teen;
      case "12":
        return CustomIcons.twelve;
      case "14":
        return CustomIcons.fourteen;
      case "16":
        return CustomIcons.sixteen;
      case "18":
        return CustomIcons.eighteen;
    }
  }
}
