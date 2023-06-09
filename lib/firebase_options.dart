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
    apiKey: 'AIzaSyCPpOMlza_ZclZAPiMt7hEC1H8_xeU3eRg',
    appId: '1:512000334631:web:7b4b3eb5e6e6467603a702',
    messagingSenderId: '512000334631',
    projectId: 'myeduate-48fee',
    authDomain: 'myeduate-48fee.firebaseapp.com',
    storageBucket: 'myeduate-48fee.appspot.com',
    measurementId: 'G-XD4WRX9H8E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzZqA7A9_GZiA5R1zWxAse53BFniQpBIM',
    appId: '1:512000334631:android:ab084b8d3240dd6f03a702',
    messagingSenderId: '512000334631',
    projectId: 'myeduate-48fee',
    storageBucket: 'myeduate-48fee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7EcDvBBAShw-ZHqj66qQf3N7KWIn_tdA',
    appId: '1:512000334631:ios:d91c855e0b08149603a702',
    messagingSenderId: '512000334631',
    projectId: 'myeduate-48fee',
    storageBucket: 'myeduate-48fee.appspot.com',
    iosClientId: '512000334631-vvng6itaj7egf40jmbc5a90d2s814k8e.apps.googleusercontent.com',
    iosBundleId: 'com.pyramid.myeduate',
  );
}
