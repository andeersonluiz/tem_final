import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tem_final/src/core/resources/no_connection_exception.dart';
import 'package:tem_final/src/core/utils/strings.dart';

class ConnectionVerifyer implements Exception {
  static Future<bool> verify() async {
    bool connectionStatus = await InternetConnectionChecker().hasConnection;
    if (!connectionStatus) {
      return throw NoConnectionException(message: Strings.noConnection);
    }
    return true;
  }
}
