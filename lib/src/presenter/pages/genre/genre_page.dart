import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/presenter/ad_helper.dart';
import 'package:tem_final/src/presenter/pages/search/widgets/search_item.dart';
import 'package:tem_final/src/presenter/reusableWidgets/ad_banner_widger.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_button.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_outline_button.dart';
import 'package:tem_final/src/presenter/reusableWidgets/error_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/ad/ad_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/ad/ad_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/genres/genre_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/genres/genre_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/genres/genre_state.dart';
import 'package:tem_final/src/presenter/stateManagement/valueNotifier/local_filter_notifier.dart';
import 'package:tuple/tuple.dart';

import '../../../core/utils/routes_names.dart';
import '../../stateManagement/bloc/ad/ad_bloc.dart';
import '../../stateManagement/bloc/favorite/favorite_state.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key, required this.indexGenre});
  final int indexGenre;
  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage>
    with SingleTickerProviderStateMixin {
  late GenreBloc genreBloc;
  late GenreType genre;
  late FavoriteBloc favoriteBloc;
  late ScrollController controller;
  late LocalFilterNotifier filterNotifier;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AdBloc adBloc;

  @override
  void initState() {
    genreBloc = context.read<GenreBloc>();
    favoriteBloc = context.read<FavoriteBloc>();
    filterNotifier = context.read<LocalFilterNotifier>();
    genre = GenreType.values[widget.indexGenre];
    genreBloc.add(GetGenreEvent(
        genreType: genre,
        filters: const Tuple2(Filter.all, FilterGenre.popularity)));

    controller = ScrollController()..addListener(_scrollListener);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    adBloc = context.read<AdBloc>();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          adBloc.add(UpdateBannerAd(bannerAd: ad as BannerAd));
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500 && !genreBloc.isFinalList) {
      genreBloc.add(const LoadMoreGenreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreBloc, GenreState>(builder: (context, state) {
      if (state is GenreDone) {
        _animationController.forward();
        return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(genre.string),
              actions: [
                IconButton(
                    onPressed: () {
                      _showModalBottomSheet(state.filters);
                    },
                    icon: const Icon(FontAwesomeIcons.sliders))
              ],
            ),
            body: FadeTransition(
              opacity: _animation,
              child: BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, stateFavorite) {
                CustomToast(msg: stateFavorite.msg);
                if (stateFavorite is FavoriteError) {
                  favoriteBloc.add(const ResetFavoriteEvent());
                }
                return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.separated(
                      controller: controller,
                      itemCount: state.listTvShowAndMovie.length,
                      separatorBuilder: (context, index) {
                        if (index % kAdInverval == 0 && index != 0) {
                          return BlocBuilder<AdBloc, AdState>(
                              builder: (context, state) {
                            return AdMobBanner(
                              bannerAd: state.bannerAd,
                            );
                          });
                        } else {
                          return Container();
                        }
                      },
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0,
                                    left: 12.0,
                                    bottom: 8.0,
                                    right: 12.0),
                                child: Text(
                                  "Exibindo \"${state.filters.item1.string}\" classificado por \"${state.filters.item2.string}\"",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontFamily: fontFamily,
                                      color: ratingColorPosterMainPage,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.info, arguments: {
                                    "title":
                                        state.listTvShowAndMovie[index].title,
                                    "idTvShowAndMovie":
                                        state.listTvShowAndMovie[index].id
                                  });
                                },
                                child: SearchItem(
                                  tvShowAndMovieItem:
                                      state.listTvShowAndMovie[index],
                                  favoriteBloc: favoriteBloc,
                                  isFavorite: stateFavorite.favoriteList
                                      .contains(
                                          state.listTvShowAndMovie[index]),
                                ),
                              ),
                            ],
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Routes.info, arguments: {
                              "title": state.listTvShowAndMovie[index].title,
                              "idTvShowAndMovie":
                                  state.listTvShowAndMovie[index].id
                            });
                          },
                          child: SearchItem(
                            tvShowAndMovieItem: state.listTvShowAndMovie[index],
                            favoriteBloc: favoriteBloc,
                            isFavorite: stateFavorite.favoriteList
                                .contains(state.listTvShowAndMovie[index]),
                          ),
                        );
                      }),
                );
              }),
            ));
      } else if (state is GenreError) {
        CustomToast(msg: state.msg);
        print("error");
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.0,
            centerTitle: true,
            title: Text(genre.string),
            actions: [
              IconButton(
                  onPressed: () {
                    CustomToast(msg: state.msg);
                  },
                  icon: const Icon(FontAwesomeIcons.sliders))
            ],
          ),
          body: CustomErrorWidget(
            errorText: "",
            onRefresh: () async {
              print("genreBloc");
              genreBloc.add(GetGenreEvent(
                  genreType: genre,
                  filters: const Tuple2(Filter.all, FilterGenre.popularity)));
            },
          ),
        );
      } else {
        return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(genre.string),
              actions: [
                IconButton(
                    onPressed: () {
                      _showModalBottomSheet(state.filters);
                    },
                    icon: const Icon(FontAwesomeIcons.sliders))
              ],
            ),
            body: const CustomLoadingWidget());
      }
    });
  }

  _showModalBottomSheet(Tuple2<Filter, FilterGenre> filters) {
    filterNotifier.updateAll(filters);
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        backgroundColor: optionFilledColor,
        builder: (BuildContext context) {
          return ValueListenableBuilder<Tuple2<Filter, FilterGenre>>(
            valueListenable: filterNotifier.state,
            builder: (_, state, w) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Tipo de conteúdo:",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Filter.values
                            .map((e) => CustomOutlineButton(
                                  onPressed: () {
                                    filterNotifier.updateItem1(e);
                                  },
                                  text: e.string,
                                  selectedText:
                                      filterNotifier.state.value.item1.string,
                                  colorSelected: foregroundColor,
                                  colorUnselected: Colors.white70,
                                  padding: const EdgeInsets.all(8),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Classificar por:",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: FilterGenre.values
                            .map((e) => CustomOutlineButton(
                                  onPressed: () {
                                    filterNotifier.updateItem2(e);
                                  },
                                  text: e.string,
                                  selectedText:
                                      filterNotifier.state.value.item2.string,
                                  colorSelected: foregroundColor,
                                  colorUnselected: Colors.white70,
                                  padding: const EdgeInsets.all(8),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 12.0),
                    width: 100.w,
                    child: CustomButton(
                        onPressed: () {
                          genreBloc.add(FilterGenreEvent(
                              genreType: genre,
                              filters: filterNotifier.state.value));
                          _animationController.reset();

                          Navigator.of(context).pop();
                        },
                        text: "Filtrar",
                        fontSize: 18),
                  )
                ],
              );
            },
          );
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
