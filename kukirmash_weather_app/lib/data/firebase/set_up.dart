import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../di/di.dart';
import 'firebase_options.dart';

/// Подключаться ли к локальным эмуляторам Firebase вместо реального проекта.
///
/// Включается при запуске:
/// `flutter run --dart-define=USE_FIREBASE_EMULATORS=true`
const bool kUseFirebaseEmulators = bool.fromEnvironment('USE_FIREBASE_EMULATORS');

/// Хост эмуляторов Firebase.
const String kFirebaseEmulatorHost = '127.0.0.1';

/// Порт эмулятора Authentication.
const int kAuthEmulatorPort = 9099;

/// Порт эмулятора Cloud Firestore.
const int kFirestoreEmulatorPort = 8080;

/// Инициализирует Firebase и сообщает, доступен ли он на текущей платформе.
///
/// FlutterFire поддерживает Android, iOS, macOS, Web и Windows, но не Linux.
/// Ошибка инициализации не должна приводить к падению приложения: экраны
/// аутентификации и избранного в этом случае покажут пользователю сообщение.
Future<bool> setUpFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kUseFirebaseEmulators) {
      await FirebaseAuth.instance.useAuthEmulator(
        kFirebaseEmulatorHost,
        kAuthEmulatorPort,
      );
      FirebaseFirestore.instance.useFirestoreEmulator(
        kFirebaseEmulatorHost,
        kFirestoreEmulatorPort,
      );
    }

    return true;
  } catch (exception, stackTrace) {
    talker.handle(exception, stackTrace);
    return false;
  }
}
