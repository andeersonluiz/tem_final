import 'package:get/get.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';

class AuthController extends GetxController {
  AuthController(this._loginViaGoogleUseCase, this._logOutUseCase);
  final LoginViaGoogleUseCase _loginViaGoogleUseCase;
  final LogOutUseCase _logOutUseCase;
}
