import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/search_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_tv_show_and_movie_rating_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_user_history_rating_usecase.dart';
import 'package:tem_final/src/presenter/controllers/rating_controller.dart';
import 'package:tem_final/src/presenter/controllers/search_controller.dart';

class RatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RatingController(
          Get.find<UpdateUserHistoryRatingUseCase>(),
          Get.find<UpdateTvShowAndMovieRatingUseCase>(),
        ));
  }
}
