import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/no_param_usecase.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/domain/repositories/tv_show_and_movie_repository.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';

class MockLoginViaGoogleUseCase implements NoParamUseCase<DataState<String>> {
  MockLoginViaGoogleUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<DataState<String>> call() async {
    return await _userRepository.loginViaGoogle();
  }
}
