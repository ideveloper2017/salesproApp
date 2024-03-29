// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: "AIzaSyBt1UUtViLgtDU8orqCGDfySTbVX77V63I",
    authDomain: "bravoparfum-66ca7.firebaseapp.com",
    databaseURL: "https://bravoparfum-66ca7-default-rtdb.firebaseio.com",
    projectId: "bravoparfum-66ca7",
    storageBucket: "bravoparfum-66ca7.appspot.com",
    messagingSenderId: "455269009142",
    appId: "1:455269009142:web:5c8e44f4e2332c54d1ced7",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBt1UUtViLgtDU8orqCGDfySTbVX77V63I',
    appId: '1:455269009142:android:6634d434a7d70af7d1ced7',
    databaseURL: "https://bravoparfum-66ca7-default-rtdb.firebaseio.com",
    messagingSenderId: '455269009142',
    projectId: 'bravoparfum-66ca7',
    storageBucket: "bravoparfum-66ca7.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBt1UUtViLgtDU8orqCGDfySTbVX77V63I',
    appId: '1:455269009142:ios:89dc24b38698f3d2d1ced7',
    databaseURL: "https://bravoparfum-66ca7-default-rtdb.firebaseio.com",
    messagingSenderId: '455269009142',
    projectId: 'bravoparfum-66ca7',
    storageBucket: "bravoparfum-66ca7.appspot.com",
    iosBundleId: 'com.maantheme.mobilepo',
  );
}
