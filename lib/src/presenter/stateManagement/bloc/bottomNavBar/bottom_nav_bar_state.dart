// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/core/utils/constants.dart';

class BottomNavBarState extends Equatable {
  const BottomNavBarState(
    this.page,
  );
  final PageType page;

  @override
  List<Object> get props => [];
}

class HomePageState extends BottomNavBarState {
  const HomePageState(super.page);
}

class FavoritePageState extends BottomNavBarState {
  const FavoritePageState(super.page);
}

class SettingsPageState extends BottomNavBarState {
  const SettingsPageState(super.page);
}
