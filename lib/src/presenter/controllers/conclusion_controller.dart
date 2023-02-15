import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';

class ConclusionController extends GetxController {
  ConclusionController(
    this._selectConclusionUseCase,
  );
  final SelectConclusionUseCase _selectConclusionUseCase;
}
