import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/set_tv_serie_and_movie_with_favorite_usecase.dart';
import 'package:tem_final/src/presenter/controllers/favorite_controller.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteController(
          Get.find<SetTvSerieAndMovieWithFavoriteUseCase>(),
        ));
  }
}
