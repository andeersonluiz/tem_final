import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/search_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController(
          Get.find<SearchTvShowAndMovieUseCase>(),
          Get.find<LoadMoreTvShowAndMovieUseCase>(),
        ));
  }
}
