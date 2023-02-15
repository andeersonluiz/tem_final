import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_main_page_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/controllers/tv_shows_and_movies_controller.dart';

class TvShowsAndMoviesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TvShowsAndMoviesController(
          Get.find<GetAllTvShowAndMovieUseCase>(),
          Get.find<LoadMoreTvShowAndMovieMainPageUseCase>(),
          Get.find<GetAllMovieUseCase>(),
          Get.find<GetAllTvShowUseCase>(),
        ));
  }
}
