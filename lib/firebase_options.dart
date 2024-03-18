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
      apiKey: "AIzaSyDBnlj7lgb7HTVoX9Wi9QOE6ENqyOV55MU",
      authDomain: "salesprp-31e4a.firebaseapp.com",
      databaseURL: "https://salesprp-31e4a-default-rtdb.firebaseio.com",
      projectId: "salesprp-31e4a",
      storageBucket: "salesprp-31e4a.appspot.com",
      messagingSenderId: "980258861434",
      appId: "1:980258861434:web:ac6720286e4169b6c026c3"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBnlj7lgb7HTVoX9Wi9QOE6ENqyOV55MU',
    appId: '1:980258861434:android:60b409c3859090fcc026c3',
    messagingSenderId: '606700156156',
    projectId: 'salesprp-31e4a',
    storageBucket: 'salesprp-31e4a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAT1zNWpyIsMp29W0OEKcJ9NJa0b_HvDwE',
    appId: '1:736551413173:ios:f50c8a1a94df52472fe5fc',
    messagingSenderId: '736551413173',
    projectId: 'maanpos',
    storageBucket: 'maanpos.appspot.com',
    iosBundleId: 'com.maantheme.mobilepo',
  );
}
