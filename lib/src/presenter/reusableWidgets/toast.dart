import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  CustomToast({required this.msg, toastLength = Toast.LENGTH_LONG}) {
    if (msg.isEmpty) return;
    if (_lastToastTime == null ||
        DateTime.now().difference(_lastToastTime!).inSeconds >= 2) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: toastLength,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      _lastToastTime = DateTime.now();
    }
  }
  static DateTime? _lastToastTime;
  final String msg;
}
