import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/bottomNavBar/bottom_nav_bar_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_event.dart';

import '../stateManagement/bloc/bottomNavBar/bottom_nav_bar_bloc.dart';
import '../stateManagement/bloc/bottomNavBar/bottom_nav_bar_event.dart';
import '../stateManagement/bloc/favorite/favorite_event.dart';
import '../stateManagement/bloc/tvShowAndMovie/tv_show_and_movie_event.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  late FavoriteBloc favoriteBloc;
  late TvShowAndMovieBloc bloc;
  late BottomNavBarBloc bottomNavBarBloc;
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<TvShowAndMovieBloc>();
    favoriteBloc = context.read<FavoriteBloc>();
    userBloc = context.read<UserBloc>();

    bottomNavBarBloc = context.read<BottomNavBarBloc>();
    favoriteBloc.add(const GetFavoriteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
        builder: (context, state) {
      return FloatingNavbar(
        onTap: (index) {
          PageType pageType = PageType.values[index];
          switch (pageType) {
            case PageType.home:
              bloc.add(GetAllTvShowAndMovieEvent(Filter.all,
                  refresh: state.page != pageType));
              break;
            case PageType.favorite:
              favoriteBloc.add(const GetFavoriteEvent());

              break;
            case PageType.settings:
              userBloc.add(LoadUserEvent());

              break;
          }
          bottomNavBarBloc.add(UpdateBottomNavBarEvent(page: pageType));
        }, //tvShowAndMovieController.updateIndexSelected,
        backgroundColor: appBarColor,
        currentIndex:
            state.page.index, //tvShowAndMovieController.indexSelected.value,
        unselectedItemColor: optionFilledColor,
        selectedItemColor: textColorFilledOption,
        selectedBackgroundColor: Colors.transparent,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Início'),
          FloatingNavbarItem(icon: Icons.favorite, title: 'Favoritos'),
          FloatingNavbarItem(icon: Icons.settings, title: 'Configurações'),
        ],
      );
    });
  }
}
