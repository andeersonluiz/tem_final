import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/submit_report_usecase.dart';
import 'package:tem_final/src/presenter/controllers/feedback_controller.dart';

import '../../domain/usecases/submit_report_usecase_test.dart';
import '../controllers/feedback_controller.dart';

class MockFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MockFeedbackController(
          Get.find<MockSubmitReportUseCase>(),
        ));
  }
}
