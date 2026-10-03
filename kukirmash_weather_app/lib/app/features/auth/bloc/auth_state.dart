part of 'auth_bloc.dart';

/// Состояния аутентификации.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Состояние входа ещё не получено (проверяется сохранённая сессия).
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Выполняется вход, регистрация или выход.
final class AuthInProgress extends AuthState {
  const AuthInProgress();
}

/// Пользователь авторизован.
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final AppUser user;

  @override
  List<Object?> get props => [user];
}

/// Пользователь не авторизован.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.error});

  /// Текст последней ошибки входа, если она была.
  final String? error;

  @override
  List<Object?> get props => [error];
}
