import 'app_user.dart';

/// Интерфейс репозитория аутентификации (Firebase Authentication).
abstract interface class AuthRepositoryInterface {
  /// Поток изменений состояния входа: null — пользователь не авторизован.
  Stream<AppUser?> authStateChanges();

  /// Текущий авторизованный пользователь.
  AppUser? get currentUser;

  /// Вход по электронной почте и паролю.
  Future<AppUser> signIn({required String email, required String password});

  /// Регистрация нового пользователя по электронной почте и паролю.
  Future<AppUser> signUp({required String email, required String password});

  /// Выход из учётной записи.
  Future<void> signOut();
}
