import 'package:json_annotation/json_annotation.dart';

import 'daily_forecast.dart';
import 'hourly_forecast.dart';

part 'forecast_response.g.dart';

/// DTO ответа Open-Meteo.
///
/// Особенность API: значения приходят не массивом объектов, а «колонками» —
/// параллельными массивами [DailyBlock.time], [DailyBlock.temperatureMax] и т.д.
/// Класс разбирает такой ответ и склеивает колонки в список моделей.
@JsonSerializable()
class ForecastResponse {
  const ForecastResponse({this.daily, this.hourly});

  /// Блок суточного прогноза.
  @JsonKey(name: 'daily')
  final DailyBlock? daily;

  /// Блок почасового прогноза.
  @JsonKey(name: 'hourly')
  final HourlyBlock? hourly;

  factory ForecastResponse.fromJson(Map<String, dynamic> json) =>
      _$ForecastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastResponseToJson(this);

  /// Склеивает параллельные массивы блока daily в список моделей.
  List<DailyForecast> toDailyForecasts() {
    final block = daily;
    if (block == null) return const [];

    return List.generate(block.time.length, (index) {
      return DailyForecast(
        id: block.time[index],
        date: DateTime.parse(block.time[index]),
        weatherCode: block.weatherCode[index],
        temperatureMax: block.temperatureMax[index].toDouble(),
        temperatureMin: block.temperatureMin[index].toDouble(),
        apparentTemperatureMax: block.apparentTemperatureMax[index].toDouble(),
        apparentTemperatureMin: block.apparentTemperatureMin[index].toDouble(),
        relativeHumidity: block.relativeHumidity[index],
        surfacePressure: block.surfacePressure[index].toDouble(),
        windSpeed: block.windSpeed[index].toDouble(),
        precipitationProbability: block.precipitationProbability[index],
        sunrise: DateTime.parse(block.sunrise[index]),
        sunset: DateTime.parse(block.sunset[index]),
        uvIndex: block.uvIndex[index].toDouble(),
      );
    });
  }

  /// Склеивает параллельные массивы блока hourly в список моделей.
  List<HourlyForecast> toHourlyForecasts() {
    final block = hourly;
    if (block == null) return const [];

    return List.generate(block.time.length, (index) {
      return HourlyForecast(
        time: DateTime.parse(block.time[index]),
        temperature: block.temperature[index].toDouble(),
        relativeHumidity: block.relativeHumidity[index],
        apparentTemperature: block.apparentTemperature[index].toDouble(),
        precipitationProbability: block.precipitationProbability[index],
        weatherCode: block.weatherCode[index],
        windSpeed: block.windSpeed[index].toDouble(),
        surfacePressure: block.surfacePressure[index].toDouble(),
      );
    });
  }
}

/// Блок суточных показателей ответа Open-Meteo (параллельные массивы).
@JsonSerializable()
class DailyBlock {
  const DailyBlock({
    required this.time,
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

  /// Даты в формате ISO8601 — они же идентификаторы дней.
  final List<String> time;

  @JsonKey(name: 'weather_code')
  final List<int> weatherCode;

  @JsonKey(name: 'temperature_2m_max')
  final List<num> temperatureMax;

  @JsonKey(name: 'temperature_2m_min')
  final List<num> temperatureMin;

  @JsonKey(name: 'apparent_temperature_max')
  final List<num> apparentTemperatureMax;

  @JsonKey(name: 'apparent_temperature_min')
  final List<num> apparentTemperatureMin;

  @JsonKey(name: 'relative_humidity_2m_mean')
  final List<int> relativeHumidity;

  @JsonKey(name: 'surface_pressure_mean')
  final List<num> surfacePressure;

  @JsonKey(name: 'wind_speed_10m_max')
  final List<num> windSpeed;

  @JsonKey(name: 'precipitation_probability_max')
  final List<int> precipitationProbability;

  final List<String> sunrise;
  final List<String> sunset;

  @JsonKey(name: 'uv_index_max')
  final List<num> uvIndex;

  factory DailyBlock.fromJson(Map<String, dynamic> json) =>
      _$DailyBlockFromJson(json);

  Map<String, dynamic> toJson() => _$DailyBlockToJson(this);
}

/// Блок почасовых показателей ответа Open-Meteo (параллельные массивы).
@JsonSerializable()
class HourlyBlock {
  const HourlyBlock({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitationProbability,
    required this.weatherCode,
    required this.windSpeed,
    required this.surfacePressure,
  });

  /// Дата и время измерения в формате ISO8601.
  final List<String> time;

  @JsonKey(name: 'temperature_2m')
  final List<num> temperature;

  @JsonKey(name: 'relative_humidity_2m')
  final List<int> relativeHumidity;

  @JsonKey(name: 'apparent_temperature')
  final List<num> apparentTemperature;

  @JsonKey(name: 'precipitation_probability')
  final List<int> precipitationProbability;

  @JsonKey(name: 'weather_code')
  final List<int> weatherCode;

  @JsonKey(name: 'wind_speed_10m')
  final List<num> windSpeed;

  @JsonKey(name: 'surface_pressure')
  final List<num> surfacePressure;

  factory HourlyBlock.fromJson(Map<String, dynamic> json) =>
      _$HourlyBlockFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyBlockToJson(this);
}
