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
    apiKey: 'AIzaSyB-YgVdGe_YXe3sAijjdr4TRq2l3bOlmNU',
    appId: '1:546470862682:web:aee0386f67f46ca860dd63',
    messagingSenderId: '546470862682',
    projectId: 'hobinwarehouse',
    authDomain: 'hobinwarehouse.firebaseapp.com',
    storageBucket: 'hobinwarehouse.appspot.com',
    measurementId: 'G-53LGXRJF9N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcuWQLxVwuIkWuDrjJatN3BKCaxJiR_e4',
    appId: '1:546470862682:android:2749a9088e515db460dd63',
    messagingSenderId: '546470862682',
    projectId: 'hobinwarehouse',
    storageBucket: 'hobinwarehouse.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoC1aMJuB2nhqdlsRlsIHQUtH8c9ihG14',
    appId: '1:546470862682:ios:b51446752d367b3960dd63',
    messagingSenderId: '546470862682',
    projectId: 'hobinwarehouse',
    storageBucket: 'hobinwarehouse.appspot.com',
    androidClientId:
        '546470862682-t1ad47h6132c9ghqg3rmkndtuf2canci.apps.googleusercontent.com',
    iosClientId:
        '546470862682-qg1aq01pojlcg2s9lfentke2e2pajcgp.apps.googleusercontent.com',
    iosBundleId: 'com.example.hobinWarehouse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoC1aMJuB2nhqdlsRlsIHQUtH8c9ihG14',
    appId: '1:546470862682:ios:b51446752d367b3960dd63',
    messagingSenderId: '546470862682',
    projectId: 'hobinwarehouse',
    storageBucket: 'hobinwarehouse.appspot.com',
    androidClientId:
        '546470862682-t1ad47h6132c9ghqg3rmkndtuf2canci.apps.googleusercontent.com',
    iosClientId:
        '546470862682-qg1aq01pojlcg2s9lfentke2e2pajcgp.apps.googleusercontent.com',
    iosBundleId: 'com.example.hobinWarehouse',
  );
}
