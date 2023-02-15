import 'package:tem_final/src/core/resources/data_state.dart';

abstract class DataIntegrityChecker {
  Future<void> checkIntegrity();
  Future<DataState<bool>> checkMultiDeviceLoginStatus();
}
