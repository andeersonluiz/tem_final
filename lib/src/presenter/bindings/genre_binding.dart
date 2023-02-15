import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_by_genres_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/controllers/genre_controller.dart';

class GenreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GenreController(
          Get.find<GetTvShowAndMovieByGenresUseCase>(),
          Get.find<LoadMoreTvShowAndMovieUseCase>(),
        ));
  }
}
