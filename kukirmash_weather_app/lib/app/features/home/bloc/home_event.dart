part of 'home_bloc.dart';

/// События первого экрана.
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузка или обновление прогноза на неделю.
class HomeLoadRequested extends HomeEvent {
  const HomeLoadRequested({this.completer});

  /// Позволяет дождаться завершения загрузки извне (например, в refresh).
  final Completer<void>? completer;

  @override
  List<Object?> get props => [];
}
