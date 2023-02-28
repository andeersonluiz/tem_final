import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/no_param_usecase.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';

class VerifiyUserIsLoggedUseCase implements NoParamUseCase<bool> {
  VerifiyUserIsLoggedUseCase(this._userRepository);
  final UserRepository _userRepository;
  @override
  Future<bool> call() async {
    return await _userRepository.verifyUserIsLogged();
  }
}
