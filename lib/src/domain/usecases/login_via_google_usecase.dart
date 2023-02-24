import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/no_param_usecase.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';

class LoginViaGoogleUseCase implements NoParamUseCase<DataState<String>> {
  LoginViaGoogleUseCase(this._userRepository);
  final UserRepository _userRepository;
  @override
  Future<DataState<String>> call() async {
    return await _userRepository.loginViaGoogle();
  }
}
