import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/controllers/tv_show_and_movie_controller.dart';
import 'package:tem_final/src/presenter/controllers/tv_shows_and_movies_controller.dart';

class TvShowAndMovieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TvShowAndMovieController(
          Get.find<GetTvShowAndMovieUseCase>(),
        ));
  }
}
