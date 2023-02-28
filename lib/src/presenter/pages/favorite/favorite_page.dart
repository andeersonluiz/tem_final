import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/presenter/pages/favorite/widgets/favorite_card_widget.dart';
import 'package:tem_final/src/presenter/pages/search/search_page.dart';
import 'package:tem_final/src/presenter/pages/search/widgets/search_item.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_bottom_navigation.dart';
import 'package:tem_final/src/presenter/reusableWidgets/error_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/bottomNavBar/bottom_nav_bar_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/bottomNavBar/bottom_nav_bar_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/search/search_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_event.dart';

import '../../stateManagement/bloc/bottomNavBar/bottom_nav_bar_state.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late FavoriteBloc favoriteBloc;
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    favoriteBloc = context.read<FavoriteBloc>();
    favoriteBloc.add(const GetFavoriteEvent());
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
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
                  delegate:
                      SearchPage(context.read<SearchBloc>(), favoriteBloc),
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Meus Favoritos",
              style: TextStyle(
                  fontFamily: fontFamily,
                  color: ratingColorPosterMainPage,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
            if (state is FavoriteDone) {
              if (state.favoriteList.isEmpty) {
                return const Expanded(
                  child: CustomErrorWidget(
                      errorText: "Sua lista de favoritos está vazia"),
                );
              }
              if (state is FavoriteToastDone) {
                if (state.isFavorite) {
                  CustomToast(msg: state.msg);
                }
                favoriteBloc.add(UpdateFavoriteEvent());
              }
              return Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: FadeTransition(
                    opacity: _animation,
                    child: ListView.builder(
                      itemCount: state.favoriteList.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Routes.info, arguments: {
                              "title": state.favoriteList[index].title,
                              "idTvShowAndMovie": state.favoriteList[index].id
                            });
                          },
                          child: FavoriteCard(
                              tvShowAndMovieItem: state.favoriteList[index],
                              favoriteBloc: favoriteBloc,
                              isFavorite: true),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else if (state is FavoriteError) {
              CustomToast(msg: state.msg);
            }
            return const Expanded(child: CustomLoadingWidget());
          }),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
