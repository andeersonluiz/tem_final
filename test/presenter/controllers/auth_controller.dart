import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';

import '../../domain/usecases/log_out_usecase_test.dart';
import '../../domain/usecases/login_via_google_usecase_test.dart';

class MockAuthController extends GetxController {
  MockAuthController(this._loginViaGoogleUseCase, this._logOutUseCase);
  final MockLoginViaGoogleUseCase _loginViaGoogleUseCase;
  final MockLogOutUseCase _logOutUseCase;
}
