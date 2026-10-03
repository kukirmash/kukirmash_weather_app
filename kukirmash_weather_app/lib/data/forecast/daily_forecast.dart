import 'package:equatable/equatable.dart';

import 'weather_condition.dart';

/// Модель одного дня прогноза — элемент списка на первом экране.
///
/// Поле [id] (дата в формате ISO) одновременно является идентификатором,
/// по которому второй экран запрашивает подробные данные.
class DailyForecast extends Equatable {
  const DailyForecast({
    required this.id,
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMin,
    required this.relativeHumidity,
    required this.surfacePressure,
    required this.windSpeed,
    required this.precipitationProbability,
    required this.sunrise,
    required this.sunset,
    required this.uvIndex,
  });

  /// Идентификатор дня — дата в формате ISO (например, 2026-10-04).
  final String id;

  /// Дата прогноза.
  final DateTime date;

  /// Код погоды WMO.
  final int weatherCode;

  /// Максимальная температура воздуха, °C.
  final double temperatureMax;

  /// Минимальная температура воздуха, °C.
  final double temperatureMin;

  /// Максимальная ощущаемая температура, °C.
  final double apparentTemperatureMax;

  /// Минимальная ощущаемая температура, °C.
  final double apparentTemperatureMin;

  /// Средняя относительная влажность, %.
  final int relativeHumidity;

  /// Среднее атмосферное давление, гПа.
  final double surfacePressure;

  /// Максимальная скорость ветра, км/ч.
  final double windSpeed;

  /// Максимальная вероятность осадков, %.
  final int precipitationProbability;

  /// Время восхода.
  final DateTime sunrise;

  /// Время заката.
  final DateTime sunset;

  /// Максимальный УФ-индекс.
  final double uvIndex;

  /// Состояние погоды, полученное из кода WMO.
  WeatherCondition get condition => WeatherCondition.fromCode(weatherCode);

  /// Путь к картинке состояния погоды.
  String get imagePath => condition.imagePath;

  /// Текстовое описание состояния погоды.
  String get conditionText => condition.description;

  /// Атмосферное давление в мм ртутного столба.
  double get pressureMmHg => surfacePressure * 0.750062;

  /// Дата в виде «4 Октября, Пт».
  String get formattedDate => '${date.day} ${_months[date.month - 1]}, '
      '${_weekdays[date.weekday - 1]}';

  /// Время восхода в формате ЧЧ:ММ.
  String get formattedSunrise => _time(sunrise);

  /// Время заката в формате ЧЧ:ММ.
  String get formattedSunset => _time(sunset);

  static const List<String> _months = [
    'Января',
    'Февраля',
    'Марта',
    'Апреля',
    'Мая',
    'Июня',
    'Июля',
    'Августа',
    'Сентября',
    'Октября',
    'Ноября',
    'Декабря',
  ];

  static const List<String> _weekdays = [
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Вс',
  ];

  static String _time(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';

  @override
  List<Object?> get props => [
    id,
    date,
    weatherCode,
    temperatureMax,
    temperatureMin,
    apparentTemperatureMax,
    apparentTemperatureMin,
    relativeHumidity,
    surfacePressure,
    windSpeed,
    precipitationProbability,
    sunrise,
    sunset,
    uvIndex,
  ];
}
