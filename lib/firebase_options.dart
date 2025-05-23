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
    apiKey: 'AIzaSyAOlI_0kfdYDi_362w1Kdy7D2CpQ50ieHs',
    appId: '1:1032897987460:web:91c4a5019bc358465853d1',
    messagingSenderId: '1032897987460',
    projectId: 'library-project-9d34d',
    authDomain: 'library-project-9d34d.firebaseapp.com',
    storageBucket: 'library-project-9d34d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1so9-Vk_qmvJDAcZUyZzHeDyFRDUJgTQ',
    appId: '1:1032897987460:android:ec67a9cb55bf99815853d1',
    messagingSenderId: '1032897987460',
    projectId: 'library-project-9d34d',
    storageBucket: 'library-project-9d34d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB84eejjZF9v2-D1Y7qvynXBbWxBdzh6wQ',
    appId: '1:1032897987460:ios:7f2e220dee72470b5853d1',
    messagingSenderId: '1032897987460',
    projectId: 'library-project-9d34d',
    storageBucket: 'library-project-9d34d.appspot.com',
    androidClientId: '1032897987460-9cevecitciurb8ndiruuf0i3jh4eva6o.apps.googleusercontent.com',
    iosClientId: '1032897987460-nnijkhpd4sp6mklkjtlnip01agucfvi8.apps.googleusercontent.com',
    iosBundleId: 'com.example.libAdmin',
  );
}
