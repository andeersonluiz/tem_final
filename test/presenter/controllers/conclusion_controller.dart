import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';

import '../../domain/usecases/select_conclusion_usecase_test.dart';

class MockConclusionController extends GetxController {
  MockConclusionController(
    this._selectConclusionUseCase,
  );
  final MockSelectConclusionUseCase _selectConclusionUseCase;
}
