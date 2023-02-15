import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/update_view_count_usecase.dart';
import 'package:tem_final/src/presenter/controllers/analytics_controller.dart';

import '../../domain/usecases/update_view_count_usecase_test.dart';
import '../controllers/analytics_controller.dart';

class MockAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MockAnalyticsController(
          Get.find<MockupdateTvShowAndMovieViewCountUseCase>(),
        ));
  }
}
