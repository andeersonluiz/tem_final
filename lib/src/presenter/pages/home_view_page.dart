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
import 'package:tem_final/src/injection.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_event.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/tiles/tv_show_and_movie_tile.dart';
import 'package:tuple/tuple.dart';

import '../stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_bloc.dart';
import '../stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_state.dart';

class HomeViewPage extends StatefulWidget {
  const HomeViewPage({super.key});

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  late ScrollController controller;
  late TvShowAndMovieBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = context.read<TvShowAndMovieBloc>();
    bloc.add(GetAllTvShowAndMovieEvent(Filter.tvShow));

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
              onPressed: () {},
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
                _CustomOutlineButton(
                    onPressed: () {
                      bloc.add(GetAllTvShowAndMovieEvent(Filter.all));
                    },
                    text: Filter.all.string,
                    selectedText: state.filterSelected),
                _CustomOutlineButton(
                  onPressed: () {
                    bloc.add(GetAllMovieEvent(Filter.movie));
                  },
                  text: Filter.movie.string,
                  selectedText: state.filterSelected,
                ),
                _CustomOutlineButton(
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
              return _ListTvShowAndMovie(state.data!, controller);
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

class _CustomOutlineButton extends StatelessWidget {
  const _CustomOutlineButton(
      {required this.onPressed,
      required this.text,
      required this.selectedText});
  final void Function()? onPressed;
  final String text;
  final String selectedText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: text == selectedText
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: optionFilledColor,
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
}

class _ListTvShowAndMovie extends StatelessWidget {
  const _ListTvShowAndMovie(this.listTvShowAndMovie, this.controller);
  final ScrollController controller;
  final List<Tuple2<String, List<TvShowAndMovie>>> listTvShowAndMovie;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
              controller: controller,
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
                                          GoRouter.of(context)
                                              .pushNamed(Routes.info, params: {
                                            "title": item.title,
                                            "idTvShowAndMovie": item.id
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
              })),
    );
  }
}
