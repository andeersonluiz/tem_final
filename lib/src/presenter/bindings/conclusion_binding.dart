import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';
import 'package:tem_final/src/presenter/controllers/conclusion_controller.dart';

class ConclusionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConclusionController(
          Get.find<SelectConclusionUseCase>(),
        ));
  }
}
