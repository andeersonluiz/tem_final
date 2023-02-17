import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/get_local_user_history_usecase.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';
import 'package:tem_final/src/presenter/controllers/auth_controller.dart';
import 'package:tem_final/src/presenter/controllers/user_history_controller.dart';

class UserHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserHistoryController(
          Get.find<GetLocalUserHistoryUseCase>(),
        ));
  }
}
