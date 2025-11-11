import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC1mXZj3uHgpDJhc8oXMjcCUnQEXpNmkIA',
    appId: '1:279703611443:web:ffd4f00469011991919b46',
    messagingSenderId: '279703611443',
    projectId: 'green-time-app',
    authDomain: 'green-time-app.firebaseapp.com',
    storageBucket: 'green-time-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1mXZj3uHgpDJhc8oXMjcCUnQEXpNmkIA',
    appId: '1:279703611443:android:ffd4f00469011991919b46',
    messagingSenderId: '279703611443',
    projectId: 'green-time-app',
    storageBucket: 'green-time-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1mXZj3uHgpDJhc8oXMjcCUnQEXpNmkIA',
    appId: '1:279703611443:ios:ffd4f00469011991919b46',
    messagingSenderId: '279703611443',
    projectId: 'green-time-app',
    storageBucket: 'green-time-app.firebasestorage.app',
    iosBundleId: 'com.example.hi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC1mXZj3uHgpDJhc8oXMjcCUnQEXpNmkIA',
    appId: '1:279703611443:windows:ffd4f00469011991919b46',
    messagingSenderId: '279703611443',
    projectId: 'green-time-app',
    storageBucket: 'green-time-app.firebasestorage.app',
  );
}