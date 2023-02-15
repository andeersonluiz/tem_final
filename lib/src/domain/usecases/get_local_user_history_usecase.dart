import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/no_param_usecase.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';

class GetLocalUserHistoryUseCase
    implements NoParamUseCase<DataState<UserHistory?>> {
  GetLocalUserHistoryUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<DataState<UserHistory?>> call() async {
    return await _userRepository.getLocalUserHistory();
  }
}
