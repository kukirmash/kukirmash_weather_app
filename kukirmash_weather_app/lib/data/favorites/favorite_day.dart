import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../forecast/forecast.dart';

part 'favorite_day.g.dart';

/// Документ коллекции избранных дней в Cloud Firestore.
///
/// Путь документа: `users/{uid}/favorites/{id}`, где [id] — дата дня.
@JsonSerializable()
class FavoriteDay extends Equatable {
  const FavoriteDay({
    required this.id,
    required this.condition,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.addedAt,
  });

  /// Идентификатор дня — дата в формате ISO.
  final String id;

  /// Текстовое описание состояния погоды.
  final String condition;

  /// Максимальная температура дня, °C.
  final double temperatureMax;

  /// Минимальная температура дня, °C.
  final double temperatureMin;

  /// Когда день добавлен в избранное.
  final DateTime addedAt;

  /// Создаёт документ избранного из дня прогноза.
  factory FavoriteDay.fromForecast(DailyForecast forecast) => FavoriteDay(
    id: forecast.id,
    condition: forecast.conditionText,
    temperatureMax: forecast.temperatureMax,
    temperatureMin: forecast.temperatureMin,
    addedAt: DateTime.now(),
  );

  factory FavoriteDay.fromJson(Map<String, dynamic> json) =>
      _$FavoriteDayFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteDayToJson(this);

  @override
  List<Object?> get props => [
    id,
    condition,
    temperatureMax,
    temperatureMin,
    addedAt,
  ];
}
