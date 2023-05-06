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
    apiKey: 'AIzaSyCigInPWl1mC36sbvdu8o6AH-GRnzOlEN8',
    appId: '1:485589107433:web:6bfb86fca0ae99dc68e678',
    messagingSenderId: '485589107433',
    projectId: 'sport-f7ae1',
    authDomain: 'sport-f7ae1.firebaseapp.com',
    storageBucket: 'sport-f7ae1.appspot.com',
    measurementId: 'G-SM418MRXNQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnLk8s9FcOGgEnB6VyIbyLHQRfz0ohhhA',
    appId: '1:485589107433:android:cd055c8bc820ff9f68e678',
    messagingSenderId: '485589107433',
    projectId: 'sport-f7ae1',
    storageBucket: 'sport-f7ae1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBIXRndW061nzVlPZLxw-pB1q--NMm2eZ0',
    appId: '1:485589107433:ios:4a96fa7a9f3c28bc68e678',
    messagingSenderId: '485589107433',
    projectId: 'sport-f7ae1',
    storageBucket: 'sport-f7ae1.appspot.com',
    iosClientId: '485589107433-5r6ec93vuhahnramehold5ijbb8893uk.apps.googleusercontent.com',
    iosBundleId: 'com.example.sport',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBIXRndW061nzVlPZLxw-pB1q--NMm2eZ0',
    appId: '1:485589107433:ios:4a96fa7a9f3c28bc68e678',
    messagingSenderId: '485589107433',
    projectId: 'sport-f7ae1',
    storageBucket: 'sport-f7ae1.appspot.com',
    iosClientId: '485589107433-5r6ec93vuhahnramehold5ijbb8893uk.apps.googleusercontent.com',
    iosBundleId: 'com.example.sport',
  );
}
