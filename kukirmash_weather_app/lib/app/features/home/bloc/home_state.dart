part of 'home_bloc.dart';

/// Состояния первого экрана.
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Данные ещё не запрашивались.
final class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Идёт первичная загрузка списка.
final class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Прогноз успешно получен.
final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.days,
    required this.updatedAt,
    this.refreshError,
  });

  final List<DailyForecast> days;
  final DateTime updatedAt;

  /// Ошибка фонового обновления: старые данные при этом остаются на экране.
  final Object? refreshError;

  @override
  List<Object?> get props => [days, updatedAt, refreshError];
}

/// Загрузка завершилась ошибкой, данных для показа нет.
final class HomeError extends HomeState {
  const HomeError({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
