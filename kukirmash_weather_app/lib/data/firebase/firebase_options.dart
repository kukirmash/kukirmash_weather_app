// ВАЖНО: этот файл создаётся командой
//
//     flutterfire configure
//
// из корня проекта. Она связывает Flutter-проект с проектом Firebase и
// записывает сюда ключи для каждой платформы, после чего этот файл нужно
// заменить целиком.
//
// Значения ниже — заглушка, позволяющая проекту собираться до настройки
// собственного проекта Firebase. С реальными ключами их можно получить
// в консоли Firebase: Настройки проекта → Ваши приложения.
//
// ВАЖНО: файл не нужно коммитить в открытый репозиторий, если ключи
// ограничены по приложениям/доменам.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Настройки Firebase по умолчанию для текущей платформы.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        // Остальные платформы (в том числе Linux) FlutterFire не поддерживает.
        throw UnsupportedError(
          'DefaultFirebaseOptions не поддерживает платформу '
          '$defaultTargetPlatform. Firebase доступен на Android, iOS, '
          'macOS, Web и Windows.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'ЗАМЕНИТЕ_НА_API_KEY_ANDROID',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'kukirmash-weather-app',
    storageBucket: 'kukirmash-weather-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'ЗАМЕНИТЕ_НА_API_KEY_IOS',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'kukirmash-weather-app',
    storageBucket: 'kukirmash-weather-app.appspot.com',
    iosBundleId: 'com.example.kukirmashWeatherApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'ЗАМЕНИТЕ_НА_API_KEY_MACOS',
    appId: '1:000000000000:macos:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'kukirmash-weather-app',
    storageBucket: 'kukirmash-weather-app.appspot.com',
    iosBundleId: 'com.example.kukirmashWeatherApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'ЗАМЕНИТЕ_НА_API_KEY_WINDOWS',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'kukirmash-weather-app',
    authDomain: 'kukirmash-weather-app.firebaseapp.com',
    storageBucket: 'kukirmash-weather-app.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'ЗАМЕНИТЕ_НА_API_KEY_WEB',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'kukirmash-weather-app',
    authDomain: 'kukirmash-weather-app.firebaseapp.com',
    storageBucket: 'kukirmash-weather-app.appspot.com',
  );
}
