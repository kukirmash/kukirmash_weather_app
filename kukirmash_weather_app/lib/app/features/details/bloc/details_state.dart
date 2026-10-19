part of 'details_bloc.dart';

/// Состояния второго экрана.
sealed class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object?> get props => [];
}

/// Подробности ещё не запрашивались.
final class DetailsInitial extends DetailsState {
  const DetailsInitial();
}

/// Идёт загрузка подробностей дня.
final class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

/// Подробности дня успешно получены.
final class DetailsLoaded extends DetailsState {
  const DetailsLoaded({required this.details, this.refreshError});

  final DayDetails details;

  /// Ошибка фонового обновления: ранее загруженные данные остаются.
  final Object? refreshError;

  @override
  List<Object?> get props => [details, refreshError];
}

/// Загрузка завершилась ошибкой, данных для показа нет.
final class DetailsError extends DetailsState {
  const DetailsError({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
