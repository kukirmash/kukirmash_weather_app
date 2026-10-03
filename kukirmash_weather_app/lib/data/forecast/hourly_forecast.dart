import 'package:equatable/equatable.dart';

import 'weather_condition.dart';

/// Модель почасового прогноза — элемент списка на втором экране.
class HourlyForecast extends Equatable {
  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitationProbability,
    required this.weatherCode,
    required this.windSpeed,
    required this.surfacePressure,
  });

  /// Дата и время измерения.
  final DateTime time;

  /// Температура воздуха, °C.
  final double temperature;

  /// Относительная влажность, %.
  final int relativeHumidity;

  /// Ощущаемая температура, °C.
  final double apparentTemperature;

  /// Вероятность осадков, %.
  final int precipitationProbability;

  /// Код погоды WMO.
  final int weatherCode;

  /// Скорость ветра, км/ч.
  final double windSpeed;

  /// Атмосферное давление, гПа.
  final double surfacePressure;

  /// Состояние погоды, полученное из кода WMO.
  WeatherCondition get condition => WeatherCondition.fromCode(weatherCode);

  /// Путь к картинке состояния погоды.
  String get imagePath => condition.imagePath;

  /// Текстовое описание состояния погоды.
  String get conditionText => condition.description;

  /// Время в формате ЧЧ:00.
  String get formattedTime =>
      '${time.hour.toString().padLeft(2, '0')}:00';

  /// Атмосферное давление в мм ртутного столба.
  double get pressureMmHg => surfacePressure * 0.750062;

  @override
  List<Object?> get props => [
    time,
    temperature,
    relativeHumidity,
    apparentTemperature,
    precipitationProbability,
    weatherCode,
    windSpeed,
    surfacePressure,
  ];
}
