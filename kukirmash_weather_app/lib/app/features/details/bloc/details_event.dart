part of 'details_bloc.dart';

/// События второго экрана.
sealed class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

/// Загрузка подробностей дня по его идентификатору.
class DetailsLoad extends DetailsEvent {
  const DetailsLoad({required this.id, this.completer});

  /// Идентификатор дня — дата в формате ISO (например, 2026-10-04).
  final String id;

  /// Позволяет дождаться завершения загрузки извне (например, в refresh).
  final Completer? completer;

  @override
  List<Object> get props => [id];
}
