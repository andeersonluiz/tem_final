// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDONMT1laDvfk9_BpJ3HxRLjH9moRgdAW4',
    appId: '1:101646953492:web:9a5d049a4d74894ddacb01',
    messagingSenderId: '101646953492',
    projectId: 'temfinal-7b33f',
    authDomain: 'temfinal-7b33f.firebaseapp.com',
    storageBucket: 'temfinal-7b33f.appspot.com',
    measurementId: 'G-2C1T3HGT4B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7AQEZWpdSpSUNdI2frcMR9bqth5YqXuA',
    appId: '1:101646953492:android:c19d4b20b8f03e2cdacb01',
    messagingSenderId: '101646953492',
    projectId: 'temfinal-7b33f',
    storageBucket: 'temfinal-7b33f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAG1xHFDw4t3x384Z0oUpW4jla_KulHFBo',
    appId: '1:101646953492:ios:e0915a677cd2fa9bdacb01',
    messagingSenderId: '101646953492',
    projectId: 'temfinal-7b33f',
    storageBucket: 'temfinal-7b33f.appspot.com',
    iosClientId:
        '101646953492-3vm18i4btlvde414khl6ilsl7asdhpv5.apps.googleusercontent.com',
    iosBundleId: 'com.example.temFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAG1xHFDw4t3x384Z0oUpW4jla_KulHFBo',
    appId: '1:101646953492:ios:e0915a677cd2fa9bdacb01',
    messagingSenderId: '101646953492',
    projectId: 'temfinal-7b33f',
    storageBucket: 'temfinal-7b33f.appspot.com',
    iosClientId:
        '101646953492-3vm18i4btlvde414khl6ilsl7asdhpv5.apps.googleusercontent.com',
    iosBundleId: 'com.example.temFinal',
  );
}