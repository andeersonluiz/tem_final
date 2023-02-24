import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/presenter/pages/home/widgets/list_tv_show_and_movie_widget.dart';
import 'package:tem_final/src/presenter/pages/search/search_page.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_outline_button.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/search/search_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_event.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/tiles/tv_show_and_movie_tile.dart';
import 'package:tuple/tuple.dart';

import '../../stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_bloc.dart';
import '../../stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_state.dart';

class HomeViewPage extends StatefulWidget {
  const HomeViewPage({super.key});

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  late ScrollController controller;
  late TvShowAndMovieBloc bloc;
  late FavoriteBloc favoriteBloc;
  @override
  void initState() {
    super.initState();
    bloc = context.read<TvShowAndMovieBloc>();
    favoriteBloc = context.read<FavoriteBloc>();

    bloc.add(GetAllTvShowAndMovieEvent(Filter.tvShow));
    favoriteBloc.add(const GetFavoriteEvent());
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500 && !bloc.isFinalList) {
      bloc.add(LoadingMoreEvent(bloc.filterSelected!));
    }
  }

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
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchPage(
                      context.read<SearchBloc>(), context.read<FavoriteBloc>()),
                );
              },
              icon: const Icon(
                Icons.search,
                color: colorSearch,
              ))
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<TvShowAndMovieBloc, TvShowAndMovieState>(
              builder: (_, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomOutlineButton(
                    onPressed: () {
                      bloc.add(GetAllTvShowAndMovieEvent(Filter.all));
                    },
                    text: Filter.all.string,
                    selectedText: state.filterSelected),
                CustomOutlineButton(
                  onPressed: () {
                    bloc.add(GetAllMovieEvent(Filter.movie));
                  },
                  text: Filter.movie.string,
                  selectedText: state.filterSelected,
                ),
                CustomOutlineButton(
                  onPressed: () {
                    bloc.add(GetAllTvShowEvent(Filter.tvShow));
                  },
                  text: Filter.tvShow.string,
                  selectedText: state.filterSelected,
                ),
              ],
            );
          }),
          BlocBuilder<TvShowAndMovieBloc, TvShowAndMovieState>(
              builder: (_, state) {
            if (state is TvShowAndMovieLoading) {
              return const Expanded(
                child: CustomLoadingWidget(),
              );
            }
            if (state is TvShowAndMovieError) {
              CustomToast(msg: state.error!);
              return Container();
            }
            if (state is TvShowAndMovieDone) {
              return ListTvShowAndMovie(state.data!, controller);
            }
            return const SizedBox();
          })
        ],
      ),
      bottomNavigationBar: Builder(builder: (context) {
        return FloatingNavbar(
          onTap: null, //tvShowAndMovieController.updateIndexSelected,
          backgroundColor: appBarColor,
          currentIndex: 0, //tvShowAndMovieController.indexSelected.value,
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
