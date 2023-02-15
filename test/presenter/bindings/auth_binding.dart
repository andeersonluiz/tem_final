import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';
import 'package:tem_final/src/presenter/controllers/auth_controller.dart';

import '../../domain/usecases/log_out_usecase_test.dart';
import '../../domain/usecases/login_via_google_usecase_test.dart';
import '../controllers/auth_controller.dart';

class MockAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MockAuthController(
          Get.find<MockLoginViaGoogleUseCase>(),
          Get.find<MockLogOutUseCase>(),
        ));
  }
}
