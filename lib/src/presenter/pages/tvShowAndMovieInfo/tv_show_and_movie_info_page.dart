import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_feedback.dart';
import 'package:tem_final/src/presenter/reusableWidgets/error_widget.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/analytics/analytics_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/analytics/analytics_event.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/info_widget.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/poster_info_widget.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/select_option_widget.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_event.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/valueNotifier/local_rating_notifier.dart';

import '../../stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_state.dart';

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

class _TvShowAndMovieInfoPageState extends State<TvShowAndMovieInfoPage>
    with SingleTickerProviderStateMixin {
  late TvShowAndMovieInfoBloc tvShowAndMovieInfoBloc;
  late LocalRatingNotifier localRatingNotifier;
  late FavoriteBloc favoriteBloc;
  late AnalyticsBloc analyticsBloc;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    favoriteBloc = context.read<FavoriteBloc>();
    analyticsBloc = context.read<AnalyticsBloc>();
    tvShowAndMovieInfoBloc = context.read<TvShowAndMovieInfoBloc>();
    tvShowAndMovieInfoBloc
        .add(GetTvShowAndMovieEvent(id: widget.idTvShowAndMovie));
    favoriteBloc
        .add(GetFavoriteEvent(idTvShowAndMovie: widget.idTvShowAndMovie));
    analyticsBloc
        .add(UpdateViewCountEvent(idTvShowAndMovie: widget.idTvShowAndMovie));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowAndMovieInfoBloc, TvShowAndMovieInfoState>(
        builder: (context, state) {
      if (state is TvShowAndMovieInfoDone) {
        final TvShowAndMovie tvShowAndMovie = state.tvShowAndMovie!;
        TvShowAndMovieInfoStatus tvShowAndMovieInfoStatusSelected =
            state.tvShowAndMovieInfoStatus ??
                tvShowAndMovie.listTvShowAndMovieInfoStatusBySeason.last;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.0,
            title: AutoSizeText(widget.titleTvShowAndMovie,
                minFontSize: kMinSizeTitleInfoPage,
                maxFontSize: kMaxSizeTitleInfoPage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: fontFamily)),
            actions: [
              IconButton(
                  onPressed: () {
                    _showFeedback(ReportType.problem);
                  },
                  icon: const Icon(
                    FontAwesome.triangle_exclamation,
                    color: Colors.white,
                  )),
              BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, state) {
                if (state is FavoriteToastDone) {
                  if (state.isFavorite) {
                    CustomToast(msg: state.msg);
                  }
                  favoriteBloc.add(UpdateFavoriteEvent());
                }
                if (state is FavoriteDone) {
                  return IconButton(
                      onPressed: () {
                        favoriteBloc.add(
                            SetFavoriteEvent(tvShowAndMovie: tvShowAndMovie));
                      },
                      icon: state.isFavorite
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ));
                } else if (state is FavoriteError) {
                  CustomToast(msg: state.msg);
                  favoriteBloc.add(const ResetFavoriteEvent());
                }
                return IconButton(
                    onPressed: () {
                      favoriteBloc.add(
                          SetFavoriteEvent(tvShowAndMovie: tvShowAndMovie));
                    },
                    icon: state.isFavorite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ));
              })
            ],
          ),
          body: FadeTransition(
            opacity: _animation,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: tvShowAndMovie
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
                            isMovie: tvShowAndMovie.seasons == -1,
                          ),
                        ),
                      )
                    : CarouselSlider(
                        options: CarouselOptions(
                            initialPage: tvShowAndMovie
                                    .listTvShowAndMovieInfoStatusBySeason
                                    .length -
                                1,
                            onPageChanged: (index, _) {
                              tvShowAndMovieInfoBloc.add(
                                  UpdateTvShowAndMovieInfoStatus(
                                      tvShowAndMovieInfoStatus: tvShowAndMovie
                                              .listTvShowAndMovieInfoStatusBySeason[
                                          index]));
                            },
                            enlargeCenterPage: true,
                            viewportFraction: kViewportCarousel,
                            aspectRatio: kAspectRatioCarousel),
                        items: tvShowAndMovie
                            .listTvShowAndMovieInfoStatusBySeason
                            .asMap()
                            .entries
                            .map((item) {
                          TvShowAndMovieInfoStatus tvShowAndMovieInfoStatus =
                              item.value;

                          return PosterInfo(
                            seasonNumber: tvShowAndMovieInfoStatus.seasonNumber,
                            tvShowAndMovieInfoStatus: tvShowAndMovieInfoStatus,
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
                                    fontFamily: fontFamily,
                                    fontSize: kSizeLabelTabBarInfoPage),
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
                              SelectOptionWidget(
                                tvShowAndMovie: tvShowAndMovie,
                                indexTvShowAndMovieInfoStatusBySeason: state
                                    .tvShowAndMovie!
                                    .listTvShowAndMovieInfoStatusBySeason
                                    .indexWhere((element) =>
                                        element.seasonNumber ==
                                        tvShowAndMovieInfoStatusSelected
                                            .seasonNumber),
                              ),
                              const InfoWidget(),
                            ],
                          ))
                        ],
                      )),
                ),
              )
            ]),
          ),
        );
      } else if (state is TvShowAndMovieInfoError) {
        CustomToast(msg: state.error!);
        return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              elevation: 0.0,
              title: AutoSizeText(widget.titleTvShowAndMovie,
                  minFontSize: kMinSizeTitleInfoPage,
                  maxFontSize: kMaxSizeTitleInfoPage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: fontFamily)),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesome.triangle_exclamation,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    )),
              ],
            ),
            body: CustomErrorWidget(
              errorText: "",
              onRefresh: () async {
                tvShowAndMovieInfoBloc
                    .add(GetTvShowAndMovieEvent(id: widget.idTvShowAndMovie));
                favoriteBloc.add(GetFavoriteEvent(
                    idTvShowAndMovie: widget.idTvShowAndMovie));
                analyticsBloc.add(UpdateViewCountEvent(
                    idTvShowAndMovie: widget.idTvShowAndMovie));
              },
            ));
      } else {
        return const Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              Expanded(
                child: Center(child: CustomLoadingWidget()),
              ),
            ],
          ),
        );
      }
    });
  }

  _showFeedback(ReportType reportType) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: optionFilledColor,
        builder: (ctx) => CustomFeedback(
              reportType: reportType,
              titleTvShowAndMovie: widget.titleTvShowAndMovie,
            ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
