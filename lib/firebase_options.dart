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
    apiKey: 'AIzaSyD2OfSU-VxqXTYnaedrbz_Vua4NonRO5Mg',
    appId: '1:998235973423:web:14f08a5f2bcaa6981b23da',
    messagingSenderId: '998235973423',
    projectId: 'arabic-9b31b',
    authDomain: 'arabic-9b31b.firebaseapp.com',
    databaseURL: 'https://arabic-9b31b-default-rtdb.firebaseio.com',
    storageBucket: 'arabic-9b31b.appspot.com',
    measurementId: 'G-G1HMYMRN50',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjwQlN9mLyEdM-sTf4tpy_GXbqdSlVLvA',
    appId: '1:998235973423:android:69d7118c7110388a1b23da',
    messagingSenderId: '998235973423',
    projectId: 'arabic-9b31b',
    databaseURL: 'https://arabic-9b31b-default-rtdb.firebaseio.com',
    storageBucket: 'arabic-9b31b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDj2a1L2XwRMjWXi_k_Vy-NRVt0Gmct6Ng',
    appId: '1:998235973423:ios:cde141ae5003ae3d1b23da',
    messagingSenderId: '998235973423',
    projectId: 'arabic-9b31b',
    databaseURL: 'https://arabic-9b31b-default-rtdb.firebaseio.com',
    storageBucket: 'arabic-9b31b.appspot.com',
    iosClientId: '998235973423-m9fchb1rg62l7vcu0qdbk2ihc22qn6l6.apps.googleusercontent.com',
    iosBundleId: 'com.example.widgetApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDj2a1L2XwRMjWXi_k_Vy-NRVt0Gmct6Ng',
    appId: '1:998235973423:ios:cde141ae5003ae3d1b23da',
    messagingSenderId: '998235973423',
    projectId: 'arabic-9b31b',
    databaseURL: 'https://arabic-9b31b-default-rtdb.firebaseio.com',
    storageBucket: 'arabic-9b31b.appspot.com',
    iosClientId: '998235973423-m9fchb1rg62l7vcu0qdbk2ihc22qn6l6.apps.googleusercontent.com',
    iosBundleId: 'com.example.widgetApp',
  );
}