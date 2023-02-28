import 'package:bloc/bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/bottomNavBar/bottom_nav_bar_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/bottomNavBar/bottom_nav_bar_state.dart';

import '../../../../core/utils/constants.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc() : super(const HomePageState(PageType.home)) {
    on<UpdateBottomNavBarEvent>(_updateIndex);
  }
  PageType lastPage = PageType.home;
  Future<void> _updateIndex(
      UpdateBottomNavBarEvent event, Emitter<BottomNavBarState> emit) async {
    if (lastPage == event.page) return;
    lastPage = event.page;
    switch (event.page) {
      case PageType.home:
        emit(HomePageState(event.page));
        break;
      case PageType.favorite:
        emit(FavoritePageState(event.page));

        break;
      case PageType.settings:
        emit(SettingsPageState(event.page));
        break;
    }
  }
}
