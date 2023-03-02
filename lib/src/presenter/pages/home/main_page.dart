import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tem_final/src/presenter/pages/favorite/favorite_page.dart';
import 'package:tem_final/src/presenter/pages/home/home_view_page.dart';
import 'package:tem_final/src/presenter/pages/settings/settings_page.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/bottomNavBar/bottom_nav_bar_bloc.dart';

import '../../stateManagement/bloc/bottomNavBar/bottom_nav_bar_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late BottomNavBarBloc bottomNavBarBloc;
  @override
  void initState() {
    super.initState();
    bottomNavBarBloc = context.read<BottomNavBarBloc>();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
        builder: (context, state) {
      if (state is HomePageState) {
        return const HomeViewPage();
      } else if (state is FavoritePageState) {
        return const FavoritePage();
      } else {
        return const SettingsPage();
      }
    });
  }
}
