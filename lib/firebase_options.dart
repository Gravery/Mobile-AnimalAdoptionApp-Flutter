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
    apiKey: 'AIzaSyBOzZq38LctbF71Cq02d7hncco32x8wogg',
    appId: '1:297899706501:web:473f11fb850f1b75cf41ec',
    messagingSenderId: '297899706501',
    projectId: 'adoption-app-cfcd4',
    authDomain: 'adoption-app-cfcd4.firebaseapp.com',
    databaseURL: 'https://adoption-app-cfcd4-default-rtdb.firebaseio.com',
    storageBucket: 'adoption-app-cfcd4.appspot.com',
    measurementId: 'G-GSNRYYWD1P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ-Ej7VWu9BOeaHrOGQ8rWbjUl0cNLW0g',
    appId: '1:297899706501:android:894f46de8ec65a96cf41ec',
    messagingSenderId: '297899706501',
    projectId: 'adoption-app-cfcd4',
    databaseURL: 'https://adoption-app-cfcd4-default-rtdb.firebaseio.com',
    storageBucket: 'adoption-app-cfcd4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8XaipvMO0WlTBQQiyVcEvkp2w-qgoDlc',
    appId: '1:297899706501:ios:b4bd28a7376f2dcfcf41ec',
    messagingSenderId: '297899706501',
    projectId: 'adoption-app-cfcd4',
    databaseURL: 'https://adoption-app-cfcd4-default-rtdb.firebaseio.com',
    storageBucket: 'adoption-app-cfcd4.appspot.com',
    iosClientId: '297899706501-q4s0iiu99ubmtn8n0p6tj725skl1ijmb.apps.googleusercontent.com',
    iosBundleId: 'com.example.adoptionApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8XaipvMO0WlTBQQiyVcEvkp2w-qgoDlc',
    appId: '1:297899706501:ios:09324b35bef9c4b7cf41ec',
    messagingSenderId: '297899706501',
    projectId: 'adoption-app-cfcd4',
    databaseURL: 'https://adoption-app-cfcd4-default-rtdb.firebaseio.com',
    storageBucket: 'adoption-app-cfcd4.appspot.com',
    iosClientId: '297899706501-g1ijihd711pfu7kthejj9pp350v5pqgs.apps.googleusercontent.com',
    iosBundleId: 'com.example.adoptionApp.RunnerTests',
  );
}
