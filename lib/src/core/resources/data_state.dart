import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

abstract class DataState<T> {
  const DataState({this.data, this.error});

  final T? data;
  final Tuple2<String, StackTrace>? error;
}

class DataSucess<T> extends DataState<T> {
  const DataSucess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  DataFailed(Tuple2<String, StackTrace> error, {required this.isLog})
      : super(error: error) {
    debugPrint(error.item1);
    debugPrint(error.item2.toString());
    debugPrint("send log to FirebaseCrashlytics/removo o coment dps");
    //FirebaseCrashlytics.instance.recordError(super.error!.item1, super.error!.item2);
  }

  final bool isLog;
}
