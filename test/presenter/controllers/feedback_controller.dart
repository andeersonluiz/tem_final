import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/submit_report_usecase.dart';

import '../../domain/usecases/submit_report_usecase_test.dart';

class MockFeedbackController extends GetxController {
  MockFeedbackController(
    this._submitReportUseCase,
  );
  final MockSubmitReportUseCase _submitReportUseCase;
}
