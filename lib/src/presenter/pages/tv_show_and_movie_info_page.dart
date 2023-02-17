import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/icons.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/presenter/bindings/tv_show_and_movie_binding.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_event.dart';
import 'package:tem_final/src/presenter/controllers/rating_controller.dart';
import 'package:tem_final/src/presenter/controllers/tv_show_and_movie_controller.dart';
import 'package:tem_final/src/presenter/controllers/user_history_controller.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/valueNoifier/local_rating_notifier.dart';

import '../stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_state.dart';

class TvShowAndMovieInfoPage extends StatefulWidget {
  const TvShowAndMovieInfoPage({
    required this.idTvShowAndMovie,
    required this.titleTvShowAndMovie,
    super.key,
  });
  final String idTvShowAndMovie;
  final String titleTvShowAndMovie;

  @override
  State<TvShowAndMovieInfoPage> createState() => _TvShowAndMovieInfoPageState();
}

class _TvShowAndMovieInfoPageState extends State<TvShowAndMovieInfoPage> {
  late TvShowAndMovieInfoBloc tvShowAndMovieInfoBloc;
  late RatingBloc ratingBloc;
  late LocalRatingNotifier localRatingNotifier;
  late TvShowAndMovie tvShowAndMovie;

  @override
  void initState() {
    ratingBloc = context.read<RatingBloc>();
    tvShowAndMovieInfoBloc = context.read<TvShowAndMovieInfoBloc>();
    tvShowAndMovieInfoBloc.add(GetTvShowAndMovieEvent(widget.idTvShowAndMovie));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0.0,
          title: AutoSizeText(widget.titleTvShowAndMovie,
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
        body: WillPopScope(
          onWillPop: () async {
            ratingBloc.add(const UpdateRatingEvent(1));
            GoRouter.of(context).pop();
            return true;
          },
          child: BlocBuilder<TvShowAndMovieInfoBloc, TvShowAndMovieInfoState>(
            builder: (_, state) {
              if (state is TvShowAndMovieInfoLoading) {
                return const Column(
                  children: [
                    Expanded(
                      child: Center(child: CustomLoadingWidget()),
                    ),
                  ],
                );
              }
              if (state is TvShowAndMovieInfoDone) {
                final TvShowAndMovie? tvShowAndMovie = state.tvShowAndMovie;

                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: tvShowAndMovie!
                                .listTvShowAndMovieInfoStatusBySeason.length ==
                            1
                        ? SizedBox(
                            height: WidgetSize.heightPosterInfoPageOneSeason,
                            child: Center(
                              child: PosterInfo(
                                seasonNumber: tvShowAndMovie
                                    .listTvShowAndMovieInfoStatusBySeason
                                    .first
                                    .seasonNumber,
                                tvShowAndMovieInfoStatus: tvShowAndMovie
                                    .listTvShowAndMovieInfoStatusBySeason.first,
                              ),
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
                              TvShowAndMovieInfoStatus
                                  tvShowAndMovieInfoStatus = item.value;

                              return PosterInfo(
                                seasonNumber:
                                    tvShowAndMovieInfoStatus.seasonNumber,
                                tvShowAndMovieInfoStatus:
                                    tvShowAndMovieInfoStatus,
                              );
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
                                  _InfoWidget()
                                ],
                              ))
                            ],
                          )),
                    ),
                  )
                ]);
              }
              if (state is TvShowAndMovieInfoError) {
                CustomToast(msg: state.error!);
                return Container();
              }
              return Container();
            },
          ),
        ));
  }
}

class _InfoWidget extends StatefulWidget {
  @override
  State<_InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<_InfoWidget> {
  final TextStyle textStyle =
      const TextStyle(fontFamily: fontFamily, color: textColorFilledOption);
  late TvShowAndMovieInfoBloc tvShowAndMovieInfoBloc;
  late RatingBloc ratingBloc;
  late LocalRatingNotifier localRatingNotifier;
  late TvShowAndMovie tvShowAndMovie;

  @override
  void initState() {
    tvShowAndMovieInfoBloc = context.read<TvShowAndMovieInfoBloc>();
    ratingBloc = context.read<RatingBloc>();
    tvShowAndMovie = tvShowAndMovieInfoBloc.tvShowAndMovie;
    ratingBloc.add(UpdateRatingEvent(tvShowAndMovie.localRating));
    localRatingNotifier = context.read<LocalRatingNotifier>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                child: generateIconAgeClassification(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: BlocBuilder<RatingBloc, RatingState>(
                    builder: (_, state) {
                      print(state);
                      if (state is RatingLoading) {
                        return CustomLoadingWidget();
                      }
                      if (state is RatingDone || state is SavingRatingDone) {
                        print("chemei10 $state");
                        if (state is SavingRatingDone) {
                          print("chemei1");
                          CustomToast(
                              msg: state.sucess!,
                              toastLength: Toast.LENGTH_SHORT);
                        }
                        int ratingValue = state.ratingValue!;
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
                            ratingValue != -1
                                ? GestureDetector(
                                    onTap: () async {
                                      await _showModalBottomSheet(
                                          context,
                                          tvShowAndMovie,
                                          Strings.updateRatingText);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RatingBarIndicator(
                                        rating: ratingValue.toDouble(),
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        unratedColor:
                                            unratedColorPosterMainPage,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: ratingColorPosterMainPage,
                                        ),
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      await _showModalBottomSheet(
                                          context,
                                          tvShowAndMovie,
                                          Strings.yourRatingText);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor:
                                          ratingColorPosterMainPage, //<-- SEE HERE
                                    ),
                                    child: Text(
                                      Strings.generateButtonText(
                                          isMovie:
                                              tvShowAndMovie.seasons == -1),
                                      style: const TextStyle(
                                          fontFamily: fontFamily,
                                          color: textColorFilledOption,
                                          fontSize: 16),
                                    ),
                                  )
                          ],
                        );
                      }
                      if (state is RatingError) {
                        CustomToast(msg: state.error!);
                        return Container();
                      }
                      return Container();
                    },
                  )
                  /*Obx(() {
                 
                }),*/
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
    localRatingNotifier.update(ratingBloc.ratingValue.toDouble());
    ratingBloc.add(UpdateRatingEvent(ratingBloc.ratingValue));
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        backgroundColor: optionFilledColor,
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
                ValueListenableBuilder<double>(
                  valueListenable: localRatingNotifier.state,
                  builder: (_, state, w) {
                    return RatingBar.builder(
                      onRatingUpdate: localRatingNotifier.update,
                      minRating: 1.0,
                      initialRating: state,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 45,
                      glow: false,
                      ignoreGestures: ratingBloc.isLoading,
                      itemPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      unratedColor: unratedColorPosterMainPage,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  child:
                      BlocBuilder<RatingBloc, RatingState>(builder: (_, state) {
                    final bool isLoading = state is RatingLoading;
                    if (state is SavingRatingDone) {
                      print("chemei0");
                      CustomToast(
                          msg: state.sucess!, toastLength: Toast.LENGTH_SHORT);
                      GoRouter.of(context).pop();
                    }
                    if (state is RatingError) {
                      CustomToast(msg: state.error!);
                    }
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              ratingBloc.add(UpdateRatingEvent(
                                  localRatingNotifier.value.toInt()));
                              ratingBloc.add(SaveRatingEvent(
                                  localRatingNotifier.value.toInt(),
                                  tvShowAndMovie));
                            },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: ratingColorPosterMainPage),
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
        }).whenComplete(() {});
  }
}

class PosterInfo extends StatelessWidget {
  const PosterInfo(
      {super.key,
      required this.tvShowAndMovieInfoStatus,
      required this.seasonNumber});

  final TvShowAndMovieInfoStatus tvShowAndMovieInfoStatus;
  final int seasonNumber;
  @override
  Widget build(BuildContext context) {
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
              imageUrl: tvShowAndMovieInfoStatus.posterImageUrl,
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
}
