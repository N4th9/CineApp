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
    apiKey: 'AIzaSyClVsPKQXfqOu1Ousp2O-q1pCWH_r-Jar8',
    appId: '1:267449378738:web:c6c9426fac5859461526ab',
    messagingSenderId: '267449378738',
    projectId: 'projectcinemagic',
    authDomain: 'projectcinemagic.firebaseapp.com',
    storageBucket: 'projectcinemagic.appspot.com',
    measurementId: 'G-VMEXH4PE9E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9tNrEomZ1XbNfvFqyfgSRCh5H_Npjv4w',
    appId: '1:267449378738:android:41ed012c0d08cbdf1526ab',
    messagingSenderId: '267449378738',
    projectId: 'projectcinemagic',
    storageBucket: 'projectcinemagic.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChfBCMJxQe2ijy-vg6byhh40nFuyDAIjU',
    appId: '1:267449378738:ios:f7b5776fa3e31c011526ab',
    messagingSenderId: '267449378738',
    projectId: 'projectcinemagic',
    storageBucket: 'projectcinemagic.appspot.com',
    iosBundleId: 'com.example.project2023',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChfBCMJxQe2ijy-vg6byhh40nFuyDAIjU',
    appId: '1:267449378738:ios:a85c2e3ece5deabf1526ab',
    messagingSenderId: '267449378738',
    projectId: 'projectcinemagic',
    storageBucket: 'projectcinemagic.appspot.com',
    iosBundleId: 'com.example.project2023.RunnerTests',
  );
}
