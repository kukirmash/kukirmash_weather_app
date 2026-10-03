part of 'home_bloc.dart';

/// Состояния первого экрана.
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние — данные ещё не запрашивались.
final class HomeInitial extends HomeState {}

/// Идёт загрузка прогноза.
final class HomeLoadInProgress extends HomeState {}

/// Прогноз успешно получен.
final class HomeLoadSuccess extends HomeState {
  const HomeLoadSuccess({required this.forecast});

  final List<DailyForecast> forecast;

  @override
  List<Object> get props => [forecast];
}

/// Загрузка завершилась ошибкой.
final class HomeLoadFailure extends HomeState {
  const HomeLoadFailure({required this.exception});

  final Object exception;

  @override
  List<Object> get props => [exception];
}
