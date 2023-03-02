import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/presenter/pages/home/widgets/list_tv_show_and_movie_widget.dart';
import 'package:tem_final/src/presenter/pages/search/search_page.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_bottom_navigation.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_outline_button.dart';
import 'package:tem_final/src/presenter/reusableWidgets/error_widget.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/search/search_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_event.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';

import '../../stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_bloc.dart';
import '../../stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_state.dart';

class HomeViewPage extends StatefulWidget {
  const HomeViewPage({super.key});

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage>
    with SingleTickerProviderStateMixin {
  late ScrollController controller;
  late TvShowAndMovieBloc bloc;
  late FavoriteBloc favoriteBloc;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    bloc = context.read<TvShowAndMovieBloc>();
    bloc.add(GetAllTvShowAndMovieEvent(Filter.tvShow));
    controller = ScrollController()..addListener(_scrollListener);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
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
                      _animationController.reset();
                      bloc.add(GetAllTvShowAndMovieEvent(Filter.all));
                    },
                    text: Filter.all.string,
                    selectedText: state.filterSelected),
                CustomOutlineButton(
                  onPressed: () {
                    _animationController.reset();
                    bloc.add(GetAllMovieEvent(Filter.movie));
                  },
                  text: Filter.movie.string,
                  selectedText: state.filterSelected,
                ),
                CustomOutlineButton(
                  onPressed: () {
                    _animationController.reset();
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
              return Expanded(
                child: CustomErrorWidget(
                  errorText: "",
                  onRefresh: () async {
                    Filter filter = Filter.values
                        .where(
                            (element) => element.string == state.filterSelected)
                        .first;
                    bloc.add(GetAllTvShowAndMovieEvent(filter, refresh: true));
                  },
                ),
              );
            }
            if (state is TvShowAndMovieDone) {
              _animationController.forward();
              return Expanded(
                child: FadeTransition(
                    opacity: _animation,
                    child: ListTvShowAndMovie(state.data!, controller)),
              );
            }
            return const SizedBox();
          })
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
