// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAr98lfb0VO39RhWf17nN3PFlAgLCLuenw',
    appId: '1:111458071146:web:1c184c0549f71485ecd013',
    messagingSenderId: '111458071146',
    projectId: 'solemate-apps',
    authDomain: 'solemate-apps.firebaseapp.com',
    databaseURL: 'https://solemate-apps-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'solemate-apps.appspot.com',
    measurementId: 'G-ZDXTHHSM6L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9Wp26OskviFZwOLpewOBFu2usw8MHv98',
    appId: '1:111458071146:android:8374bdb78a5ebe65ecd013',
    messagingSenderId: '111458071146',
    projectId: 'solemate-apps',
    databaseURL: 'https://solemate-apps-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'solemate-apps.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXV8bS1Biu6JAUPAYUwy6TMgRRHFHNLUs',
    appId: '1:111458071146:ios:1e08a88085e8c16eecd013',
    messagingSenderId: '111458071146',
    projectId: 'solemate-apps',
    databaseURL: 'https://solemate-apps-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'solemate-apps.appspot.com',
    iosBundleId: 'com.example.solemateApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAXV8bS1Biu6JAUPAYUwy6TMgRRHFHNLUs',
    appId: '1:111458071146:ios:1e08a88085e8c16eecd013',
    messagingSenderId: '111458071146',
    projectId: 'solemate-apps',
    databaseURL: 'https://solemate-apps-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'solemate-apps.appspot.com',
    iosBundleId: 'com.example.solemateApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAr98lfb0VO39RhWf17nN3PFlAgLCLuenw',
    appId: '1:111458071146:web:1e6f9da825c920b9ecd013',
    messagingSenderId: '111458071146',
    projectId: 'solemate-apps',
    authDomain: 'solemate-apps.firebaseapp.com',
    databaseURL: 'https://solemate-apps-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'solemate-apps.appspot.com',
    measurementId: 'G-W0PJG5MVDF',
  );
}
