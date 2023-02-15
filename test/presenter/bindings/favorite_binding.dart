import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/set_tv_serie_and_movie_with_favorite_usecase.dart';
import 'package:tem_final/src/presenter/controllers/favorite_controller.dart';

import '../../domain/usecases/set_tv_serie_and_movie_with_favorite_usecase_test.dart';
import '../controllers/favorite_controller.dart';

class MockFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MockFavoriteController(
          Get.find<MockSetTvSerieAndMovieWithFavoriteUseCase>(),
        ));
  }
}
