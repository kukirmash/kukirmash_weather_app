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
  final DailyBlock? daily;

  /// Блок почасового прогноза.
  final HourlyBlock? hourly;

  factory ForecastResponse.fromJson(Map<String, dynamic> json) =>
      _$ForecastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastResponseToJson(this);

  /// Склеивает параллельные массивы блока daily в список моделей.
  List<DailyForecast> toDailyForecasts() {
    final block = daily;
    if (block == null) return const [];

    final count = _safeLength([
      block.time.length,
      block.weatherCode.length,
      block.temperatureMax.length,
      block.temperatureMin.length,
      block.apparentTemperatureMax.length,
      block.apparentTemperatureMin.length,
      block.relativeHumidity.length,
      block.surfacePressure.length,
      block.windSpeed.length,
      block.precipitationProbability.length,
      block.sunrise.length,
      block.sunset.length,
      block.uvIndex.length,
    ]);
    if (count == 0) return const [];

    return List.generate(count, (index) {
      final date = DateTime.tryParse(block.time[index]) ?? DateTime.now();
      return DailyForecast(
        id: block.time[index],
        date: date,
        weatherCode: block.weatherCode[index].toInt(),
        temperatureMax: block.temperatureMax[index].toDouble(),
        temperatureMin: block.temperatureMin[index].toDouble(),
        apparentTemperatureMax: block.apparentTemperatureMax[index].toDouble(),
        apparentTemperatureMin: block.apparentTemperatureMin[index].toDouble(),
        relativeHumidity: block.relativeHumidity[index].round(),
        surfacePressure: block.surfacePressure[index].toDouble(),
        windSpeed: block.windSpeed[index].toDouble(),
        precipitationProbability: block.precipitationProbability[index].round(),
        sunrise: DateTime.tryParse(block.sunrise[index]) ?? date,
        sunset: DateTime.tryParse(block.sunset[index]) ?? date,
        uvIndex: block.uvIndex[index].toDouble(),
      );
    });
  }

  /// Склеивает параллельные массивы блока hourly в список моделей.
  List<HourlyForecast> toHourlyForecasts() {
    final block = hourly;
    if (block == null) return const [];

    final count = _safeLength([
      block.time.length,
      block.temperature.length,
      block.relativeHumidity.length,
      block.apparentTemperature.length,
      block.precipitationProbability.length,
      block.weatherCode.length,
      block.windSpeed.length,
      block.surfacePressure.length,
    ]);
    if (count == 0) return const [];

    return List.generate(count, (index) {
      final time = DateTime.tryParse(block.time[index]) ?? DateTime.now();
      return HourlyForecast(
        time: time,
        temperature: block.temperature[index].toDouble(),
        relativeHumidity: block.relativeHumidity[index].round(),
        apparentTemperature: block.apparentTemperature[index].toDouble(),
        precipitationProbability: block.precipitationProbability[index].round(),
        weatherCode: block.weatherCode[index].toInt(),
        windSpeed: block.windSpeed[index].toDouble(),
        surfacePressure: block.surfacePressure[index].toDouble(),
      );
    });
  }

  /// Минимальная длина среди параллельных массивов: защищает от RangeError,
  /// если сервер вернул неполный набор данных.
  static int _safeLength(List<int> lengths) => lengths.isEmpty
      ? 0
      : lengths.reduce((value, next) => value < next ? value : next);
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
  final List<num> weatherCode;

  @JsonKey(name: 'temperature_2m_max')
  final List<num> temperatureMax;

  @JsonKey(name: 'temperature_2m_min')
  final List<num> temperatureMin;

  @JsonKey(name: 'apparent_temperature_max')
  final List<num> apparentTemperatureMax;

  @JsonKey(name: 'apparent_temperature_min')
  final List<num> apparentTemperatureMin;

  @JsonKey(name: 'relative_humidity_2m_mean')
  final List<num> relativeHumidity;

  @JsonKey(name: 'surface_pressure_mean')
  final List<num> surfacePressure;

  @JsonKey(name: 'wind_speed_10m_max')
  final List<num> windSpeed;

  @JsonKey(name: 'precipitation_probability_max')
  final List<num> precipitationProbability;

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
  final List<num> relativeHumidity;

  @JsonKey(name: 'apparent_temperature')
  final List<num> apparentTemperature;

  @JsonKey(name: 'precipitation_probability')
  final List<num> precipitationProbability;

  @JsonKey(name: 'weather_code')
  final List<num> weatherCode;

  @JsonKey(name: 'wind_speed_10m')
  final List<num> windSpeed;

  @JsonKey(name: 'surface_pressure')
  final List<num> surfacePressure;

  factory HourlyBlock.fromJson(Map<String, dynamic> json) =>
      _$HourlyBlockFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyBlockToJson(this);
}
