import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/submit_report_usecase.dart';
import 'package:tem_final/src/presenter/controllers/feedback_controller.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeedbackController(
          Get.find<SubmitReportUseCase>(),
        ));
  }
}
