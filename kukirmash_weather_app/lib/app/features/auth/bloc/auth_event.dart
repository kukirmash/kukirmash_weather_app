part of 'auth_bloc.dart';

/// События аутентификации.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Изменилось состояние входа в Firebase.
class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user, {this.error});

  final AppUser? user;

  /// Текст ошибки, если получить состояние не удалось.
  final String? error;

  @override
  List<Object?> get props => [user, error];
}

/// Вход по электронной почте и паролю.
class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Регистрация нового пользователя.
class AuthSignUpRequested extends AuthEvent {
  const AuthSignUpRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Выход из учётной записи.
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
