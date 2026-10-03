part of 'home_bloc.dart';

/// События первого экрана.
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Загрузка прогноза на неделю.
class HomeLoad extends HomeEvent {
  const HomeLoad({this.completer});

  /// Позволяет дождаться завершения загрузки извне (например, в refresh).
  final Completer? completer;

  @override
  List<Object> get props => [];
}
