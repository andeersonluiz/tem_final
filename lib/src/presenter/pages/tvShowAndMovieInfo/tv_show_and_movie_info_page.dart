import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/info_widget.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/poster_info_widget.dart';
import 'package:tem_final/src/presenter/pages/tvShowAndMovieInfo/widgets/select_option_widget.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/rating/rating_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovieInfo/tv_show_and_movie_info_event.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/valueNoifier/local_rating_notifier.dart';

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

class _TvShowAndMovieInfoPageState extends State<TvShowAndMovieInfoPage> {
  late TvShowAndMovieInfoBloc tvShowAndMovieInfoBloc;
  late RatingBloc ratingBloc;
  late LocalRatingNotifier localRatingNotifier;
  late FavoriteBloc favoriteBloc;

  @override
  void initState() {
    ratingBloc = context.read<RatingBloc>();
    favoriteBloc = context.read<FavoriteBloc>();
    tvShowAndMovieInfoBloc = context.read<TvShowAndMovieInfoBloc>();
    tvShowAndMovieInfoBloc.add(GetTvShowAndMovieEvent(widget.idTvShowAndMovie));
    favoriteBloc
        .add(GetFavoriteEvent(idTvShowAndMovie: widget.idTvShowAndMovie));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowAndMovieInfoBloc, TvShowAndMovieInfoState>(
        builder: (context, state) {
      if (state is TvShowAndMovieInfoDone) {
        final TvShowAndMovie? tvShowAndMovie = state.tvShowAndMovie;

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
              BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, state) {
                if (state is FavoriteDone) {
                  CustomToast(msg: state.msg);
                  return IconButton(
                      onPressed: () {
                        favoriteBloc.add(
                            SetFavoriteEvent(tvShowAndMovie: tvShowAndMovie!));
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
                          SetFavoriteEvent(tvShowAndMovie: tvShowAndMovie!));
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
          body: Column(children: [
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
                          viewportFraction: kViewportCarousel,
                          aspectRatio: kAspectRatioCarousel),
                      items: tvShowAndMovie.listTvShowAndMovieInfoStatusBySeason
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
                            SelectOptionWidget(tvShowAndMovie: tvShowAndMovie),
                            const InfoWidget(),
                          ],
                        ))
                      ],
                    )),
              ),
            )
          ]),
        );
      } else if (state is TvShowAndMovieInfoError) {
        CustomToast(msg: state.error!);
        return Scaffold(backgroundColor: backgroundColor, body: Container());
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
}
