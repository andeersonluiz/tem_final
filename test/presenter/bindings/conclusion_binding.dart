import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';
import 'package:tem_final/src/presenter/controllers/conclusion_controller.dart';

import '../../domain/usecases/select_conclusion_usecase_test.dart';
import '../controllers/conclusion_controller.dart';

class MockConclusionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MockConclusionController(
          Get.find<MockSelectConclusionUseCase>(),
        ));
  }
}
