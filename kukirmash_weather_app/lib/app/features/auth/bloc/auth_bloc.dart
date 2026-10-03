import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data.dart';
import '../../../../di/di.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC аутентификации: следит за состоянием входа и выполняет
/// вход, регистрацию и выход через Firebase Authentication.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(const AuthInitial()) {
    on<AuthUserChanged>(_authUserChanged);
    on<AuthSignInRequested>(_authSignInRequested);
    on<AuthSignUpRequested>(_authSignUpRequested);
    on<AuthSignOutRequested>(_authSignOutRequested);

    // Подписка на изменения состояния входа в Firebase. Если Firebase на
    // платформе недоступен, экран входа покажет сообщение только при
    // попытке входа, а не сразу при открытии.
    try {
      _subscription = authRepository.authStateChanges().listen(
        (user) => add(AuthUserChanged(user)),
        onError: (Object error, StackTrace stackTrace) {
          talker.handle(error, stackTrace);
          add(const AuthUserChanged(null));
        },
      );
    } catch (exception, stackTrace) {
      talker.handle(exception, stackTrace);
      add(const AuthUserChanged(null));
    }
  }

  final AuthRepositoryInterface authRepository;

  StreamSubscription<AppUser?>? _subscription;

  Future<void> _authUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    final user = event.user;
    if (user == null) {
      emit(AuthUnauthenticated(error: event.error));
    } else {
      emit(AuthAuthenticated(user: user));
    }
  }

  Future<void> _authSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authenticate(
      emit,
      () => authRepository.signIn(
        email: event.email,
        password: event.password,
      ),
    );
  }

  Future<void> _authSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authenticate(
      emit,
      () => authRepository.signUp(
        email: event.email,
        password: event.password,
      ),
    );
  }

  /// Общая логика входа и регистрации.
  Future<void> _authenticate(
    Emitter<AuthState> emit,
    Future<AppUser> Function() request,
  ) async {
    try {
      emit(const AuthInProgress());
      final user = await request();
      emit(AuthAuthenticated(user: user));
    } catch (exception, stackTrace) {
      emit(AuthUnauthenticated(error: exception.toString()));
      talker.handle(exception, stackTrace);
    }
  }

  Future<void> _authSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthInProgress());
      await authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (exception, stackTrace) {
      emit(AuthUnauthenticated(error: exception.toString()));
      talker.handle(exception, stackTrace);
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
