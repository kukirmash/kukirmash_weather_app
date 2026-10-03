import 'package:firebase_auth/firebase_auth.dart';

import 'app_user.dart';
import 'auth_repository_interface.dart';

/// Реализация репозитория аутентификации поверх Firebase Authentication.
class AuthRepository implements AuthRepositoryInterface {
  AuthRepository({required this.available});

  /// Доступен ли Firebase на текущей платформе (см. setUpFirebase).
  final bool available;

  /// Сообщение о недоступности Firebase, показываемое пользователю.
  static const String unavailableMessage =
      'Firebase недоступен на этой платформе или не настроен. '
      'Проверьте файл firebase_options.dart.';

  /// Ленивое обращение к FirebaseAuth: если Firebase не инициализирован,
  /// обращение к экземпляру сервиса привело бы к ошибке.
  FirebaseAuth get _auth {
    _checkAvailable();
    return FirebaseAuth.instance;
  }

  void _checkAvailable() {
    if (!available) throw const AuthException(unavailableMessage);
  }

  @override
  Stream<AppUser?> authStateChanges() {
    _checkAvailable();
    return FirebaseAuth.instance.authStateChanges().map(_toAppUser);
  }

  @override
  AppUser? get currentUser {
    _checkAvailable();
    return _toAppUser(FirebaseAuth.instance.currentUser);
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toAppUser(credential.user)!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_message(e));
    }
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toAppUser(credential.user)!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_message(e));
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    return AppUser(uid: user.uid, email: user.email);
  }

  /// Перевод кодов ошибок Firebase Authentication на русский язык.
  String _message(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => 'Некорректный адрес электронной почты.',
      'user-disabled' => 'Эта учётная запись отключена.',
      'user-not-found' => 'Пользователь с таким адресом не найден.',
      'wrong-password' ||
      'invalid-credential' => 'Неверный адрес электронной почты или пароль.',
      'email-already-in-use' =>
        'Пользователь с таким адресом уже зарегистрирован.',
      'weak-password' => 'Слишком простой пароль: минимум 6 символов.',
      'operation-not-allowed' =>
        'Вход по электронной почте не включён в консоли Firebase.',
      'network-request-failed' => 'Нет соединения с сервером Firebase.',
      _ => e.message ?? 'Не удалось выполнить вход.',
    };
  }
}

/// Ошибка аутентификации, показываемая пользователю.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
