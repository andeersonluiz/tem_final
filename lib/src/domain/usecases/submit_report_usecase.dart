import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/usecase.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';
import 'package:tuple/tuple.dart';

class SubmitReportUseCase
    implements UseCase<DataState<String>, Tuple3<String, ReportType, String>> {
  SubmitReportUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<DataState<String>> call(Tuple3<String, ReportType, String> params) {
    return _userRepository.submitReport(params);
  }
}
