import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class CustomToast {
  DateTime? _lastToastTime;
  final String msg;
  CustomToast({required this.msg, toastLength = Toast.LENGTH_LONG}) {
    if (msg.isEmpty) return;
    if (_lastToastTime == null ||
        DateTime.now().difference(_lastToastTime!).inSeconds >= 5) {
      print("exibi");
      Fluttertoast.showToast(
          msg: msg,
          toastLength: toastLength,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      _lastToastTime = DateTime.now();
    }
  }
}
