part of 'details_bloc.dart';

/// Состояния второго экрана.
sealed class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние — данные ещё не запрашивались.
final class DetailsInitial extends DetailsState {}

/// Идёт загрузка подробностей дня.
final class DetailsLoadInProgress extends DetailsState {}

/// Подробности дня успешно получены.
final class DetailsLoadSuccess extends DetailsState {
  const DetailsLoadSuccess({required this.details});

  final DayDetails details;

  @override
  List<Object> get props => [details];
}

/// Загрузка завершилась ошибкой.
final class DetailsLoadFailure extends DetailsState {
  const DetailsLoadFailure({required this.exception});

  final Object exception;

  @override
  List<Object> get props => [exception];
}
