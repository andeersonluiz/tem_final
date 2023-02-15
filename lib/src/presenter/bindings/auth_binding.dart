import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';
import 'package:tem_final/src/presenter/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(
          Get.find<LoginViaGoogleUseCase>(),
          Get.find<LogOutUseCase>(),
        ));
  }
}
