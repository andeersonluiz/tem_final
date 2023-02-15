import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_by_genres_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/controllers/genre_controller.dart';

import '../../domain/usecases/get_tv_show_and_movie_by_genres_usecase_test.dart';
import '../../domain/usecases/load_more_tv_show_and_movie_usecase_test.dart';
import '../controllers/genre_controller.dart';

class MockGenreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MockGenreController(
          Get.find<MockGetTvShowAndMovieByGenresUseCase>(),
          Get.find<MockLoadMoreTvShowAndMovieUseCase>(),
        ));
  }
}
