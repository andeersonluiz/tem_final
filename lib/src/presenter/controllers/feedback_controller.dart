import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/submit_report_usecase.dart';

class FeedbackController extends GetxController {
  FeedbackController(
    this._submitReportUseCase,
  );
  final SubmitReportUseCase _submitReportUseCase;
}
