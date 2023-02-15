import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/search_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/controllers/search_controller.dart';

import '../../domain/usecases/load_more_tv_show_and_movie_usecase_test.dart';
import '../../domain/usecases/search_tv_show_and_movie_usecase_test.dart';
import '../controllers/search_controller.dart';

class MockSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MockSearchController(
          Get.find<MockSearchTvShowAndMovieUseCase>(),
          Get.find<MockLoadMoreTvShowAndMovieUseCase>(),
        ));
  }
}
