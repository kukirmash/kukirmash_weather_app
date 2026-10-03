import 'package:equatable/equatable.dart';

/// Пользователь приложения.
///
/// Небольшая модель-обёртка над данными Firebase Authentication, чтобы
/// интерфейс не зависел напрямую от типов пакета firebase_auth.
class AppUser extends Equatable {
  const AppUser({required this.uid, this.email});

  /// Уникальный идентификатор пользователя.
  final String uid;

  /// Адрес электронной почты.
  final String? email;

  @override
  List<Object?> get props => [uid, email];
}
