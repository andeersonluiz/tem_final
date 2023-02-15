import 'package:tem_final/src/core/utils/strings.dart';

class NoConnectionException implements Exception {
  NoConnectionException(
      {required this.message, this.stackTrace = StackTrace.empty});
  final String message;
  final StackTrace stackTrace;

  @override
  String toString() => Strings.noConnection;
}
