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
    apiKey: 'AIzaSyA6jz-hxirlW_VKu-PZ_bT2OGu441JNPoc',
    appId: '1:383929334656:web:97e4795edcbf1b5eaf9f65',
    messagingSenderId: '383929334656',
    projectId: 'mil-arnet-helper-ec885',
    authDomain: 'mil-arnet-helper-ec885.firebaseapp.com',
    storageBucket: 'mil-arnet-helper-ec885.appspot.com',
    measurementId: 'G-F37X5JDJKX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOsxWTY0AzBbJNsJcFg7HdnI1Vndm2VNI',
    appId: '1:383929334656:android:867a3a841fffe5c6af9f65',
    messagingSenderId: '383929334656',
    projectId: 'mil-arnet-helper-ec885',
    storageBucket: 'mil-arnet-helper-ec885.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4XJzs-raO_0jHR_V6khBYt9_PHaduv0U',
    appId: '1:383929334656:ios:e89c90c241829282af9f65',
    messagingSenderId: '383929334656',
    projectId: 'mil-arnet-helper-ec885',
    storageBucket: 'mil-arnet-helper-ec885.appspot.com',
    iosClientId: '383929334656-3t3ueeqqdid7acdka723vgd90g0pl6d3.apps.googleusercontent.com',
    iosBundleId: 'app.zumy.mil.arnethelper.arnetHelper',
  );
}
