import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/update_view_count_usecase.dart';
import 'package:tem_final/src/presenter/controllers/analytics_controller.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnalyticsController(
          Get.find<UpdateTvShowAndMovieViewCountUseCase>(),
        ));
  }
}
