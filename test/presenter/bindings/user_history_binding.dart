import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/get_local_user_history_usecase.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';
import 'package:tem_final/src/presenter/controllers/auth_controller.dart';
import 'package:tem_final/src/presenter/controllers/user_history_controller.dart';

import '../../domain/usecases/get_local_user_history_usecase.dart';
import '../../domain/usecases/rating_tv_show_and_movie_usecase.dart';
import '../controllers/user_history_controller.dart';

class MockUserHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MockUserHistoryController(
          Get.find<MockGetLocalUserHistoryUseCase>(),
          Get.find<MockRatingTvShowAndMovieUseCase>(),
        ));
  }
}
