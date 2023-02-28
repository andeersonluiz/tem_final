import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

import '../../../core/utils/constants.dart';

class LocalFilterNotifier {
  final _state = ValueNotifier<Tuple2<Filter, FilterGenre>>(
      const Tuple2(Filter.all, FilterGenre.popularity));

  ValueListenable<Tuple2<Filter, FilterGenre>> get state => _state;

  Tuple2<Filter, FilterGenre> get value => _state.value;

  updateAll(Tuple2<Filter, FilterGenre> tuple) {
    _state.value = tuple;
  }

  updateItem1(Filter filter) {
    _state.value = Tuple2(
      filter,
      _state.value.item2,
    );
  }

  updateItem2(FilterGenre filterGenre) {
    _state.value = Tuple2(_state.value.item1, filterGenre);
  }
}
