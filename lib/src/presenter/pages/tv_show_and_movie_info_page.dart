import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/custom_icons.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/presenter/controllers/rating_controller.dart';
import 'package:tem_final/src/presenter/controllers/tv_show_and_movie_controller.dart';
import 'package:tem_final/src/presenter/controllers/user_history_controller.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';

class TvShowAndMovieInfoPage extends StatelessWidget {
  TvShowAndMovieInfoPage({
    super.key,
  });

  final args = Get.arguments;

  final TvShowAndMovieController tvShowAndMovieController =
      Get.find<TvShowAndMovieController>();
  final UserHistoryController userHistoryController =
      Get.find<UserHistoryController>();
  final RatingController ratingController = Get.find<RatingController>();
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
              style: const TextStyle(fontFamily: fontFamily)),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_border))
          ],
        ),
        body: Obx(() {
          print("attt");
          switch (
              tvShowAndMovieController.statusLoadingOnlyTvShowAndMovie.value) {
            case StatusLoadingOnlyTvShowAndMovie.firstRun:
              tvShowAndMovieController.getTvShowAndMovie(idTvShowAndMovie);
              return Container();
            case StatusLoadingOnlyTvShowAndMovie.loading:
              return const Column(
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
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: tvShowAndMovie!
                              .listTvShowAndMovieInfoStatusBySeason.length ==
                          1
                      ? SizedBox(
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
                                      text: Strings.hasEndText,
                                    ),
                                    Tab(
                                      text: Strings.infosText,
                                    ),
                                  ]),
                            ),
                            Expanded(
                                child: TabBarView(
                              children: [
                                const SizedBox(height: 50, child: Text("oi")),
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
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 400),
              fit: BoxFit.cover,
              width: WidgetSize.widthPosterInfoPage,
              height: WidgetSize.heightPosterInfoPage,
              errorWidget: (context, string, url) {
                return Container(
                  color: notFoundImageColor,
                );
              },
              imageUrl: tvShowAndMovieStatus.posterImageUrl,
              placeholder: (context, url) => Image.asset(
                    "assets/placeholderImage.gif",
                    fit: BoxFit.fill,
                  )),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "${Strings.seasonSingularText} $seasonNumber",
              style: const TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColorGenreMainPage),
            ),
          ),
        )
      ],
    );
  }

  _infoWidget(BuildContext context) {
    final TvShowAndMovie tvShowAndMovie =
        tvShowAndMovieController.tvShowAndMovie.value!;
    const TextStyle textStyle =
        TextStyle(fontFamily: fontFamily, color: textColorFilledOption);
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
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
                                  Strings.classificationText,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: textStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
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
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              tvShowAndMovie.imdbInfo.rating == -1
                                  ? "-"
                                  : "${tvShowAndMovie.imdbInfo.rating}/10",
                              style: textStyle.copyWith(fontSize: 20)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                              Strings.generateDateLastUpdate(
                                  lastUpdate:
                                      tvShowAndMovie.imdbInfo.lastUpdate),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: textStyle.copyWith(fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                  tvShowAndMovie.seasons != -1
                      ? Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Strings.seasonsText,
                                  style: textStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(tvShowAndMovie.seasons.toString(),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: textStyle.copyWith(fontSize: 20)),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            const Divider(
              color: ratingColorPosterMainPage,
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Obx(() {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Strings.myRatingText,
                          style: textStyle.copyWith(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      tvShowAndMovieController.tvShowAndMovie.value!.isRated
                          ? GestureDetector(
                              onTap: () async {
                                await _showModalBottomSheet(context,
                                    tvShowAndMovie, Strings.updateRatingText);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: RatingBarIndicator(
                                  rating: ratingController.localRating.value,
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
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                await _showModalBottomSheet(context,
                                    tvShowAndMovie, Strings.yourRatingText);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor:
                                    ratingColorPosterMainPage, //<-- SEE HERE
                              ),
                              child: Text(
                                Strings.generateButtonText(
                                    isMovie: tvShowAndMovie.seasons == -1),
                                style: const TextStyle(
                                    fontFamily: fontFamily,
                                    color: textColorFilledOption,
                                    fontSize: 16),
                              ),
                            )
                    ],
                  );
                }),
              ),
            ),
            const Divider(
              color: ratingColorPosterMainPage,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(Strings.synopsisText,
                  style: textStyle.copyWith(
                      fontSize: 20,
                      color: ratingColorPosterMainPage,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(tvShowAndMovie.synopsis,
                  textAlign: TextAlign.justify,
                  style: textStyle.copyWith(fontSize: 16)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(Strings.genresText,
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

  _showModalBottomSheet(
    BuildContext context,
    TvShowAndMovie tvShowAndMovie,
    String text,
  ) {
    ratingController.updateIsOpenShowModalBottom(true);
    Get.bottomSheet(BottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        backgroundColor: optionFilledColor,
        onClosing: () {},
        builder: (context) {
          return SizedBox(
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(text,
                      style: const TextStyle(
                          fontFamily: fontFamily,
                          color: textColorFilledOption,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                Obx(() {
                  return RatingBar.builder(
                    onRatingUpdate: (rating) {
                      ratingController.updateRatingValue(
                          tvShowAndMovie.id, rating);
                    },
                    minRating: 1.0,
                    initialRating: ratingController.ratingValue.value,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 45,
                    glow: false,
                    ignoreGestures: ratingController.statusRating.value ==
                            StatusRating.loading
                        ? true
                        : false,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: ratingController.statusRating.value ==
                              StatusRating.loading
                          ? null
                          : () async {
                              await ratingController.ratingTvShowAndMovie();
                              ratingController.isOpenShowModalBottom.value
                                  ? Get.back()
                                  : null;
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor:
                            ratingColorPosterMainPage, //<-- SEE HERE
                      ),
                      child: const Text(
                        Strings.sendRatingText,
                        style: TextStyle(
                            fontFamily: fontFamily,
                            color: textColorFilledOption,
                            fontSize: 14),
                      ),
                    );
                  }),
                )
              ],
            ),
          );
        })).whenComplete(() {
      ratingController.updateIsOpenShowModalBottom(false);
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
