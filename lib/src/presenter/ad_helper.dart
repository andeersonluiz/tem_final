import 'dart:io';

import '../config/keys.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return banerAdKey;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
