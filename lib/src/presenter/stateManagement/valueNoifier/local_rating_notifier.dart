import 'package:flutter/foundation.dart';

class LocalRatingNotifier {
  final _state = ValueNotifier<double>(0);

  ValueListenable<double> get state => _state;

  double get value => _state.value;

  void update(double newValue) {
    _state.value = newValue;
  }
}
