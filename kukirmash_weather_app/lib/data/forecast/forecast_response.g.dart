// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastResponse _$ForecastResponseFromJson(Map<String, dynamic> json) =>
    ForecastResponse(
      daily: json['daily'] == null
          ? null
          : DailyBlock.fromJson(json['daily'] as Map<String, dynamic>),
      hourly: json['hourly'] == null
          ? null
          : HourlyBlock.fromJson(json['hourly'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForecastResponseToJson(ForecastResponse instance) =>
    <String, dynamic>{'daily': instance.daily, 'hourly': instance.hourly};

DailyBlock _$DailyBlockFromJson(Map<String, dynamic> json) => DailyBlock(
  time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
  weatherCode: (json['weather_code'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  temperatureMax: (json['temperature_2m_max'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  temperatureMin: (json['temperature_2m_min'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  apparentTemperatureMax: (json['apparent_temperature_max'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  apparentTemperatureMin: (json['apparent_temperature_min'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  relativeHumidity: (json['relative_humidity_2m_mean'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  surfacePressure: (json['surface_pressure_mean'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  windSpeed: (json['wind_speed_10m_max'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  precipitationProbability:
      (json['precipitation_probability_max'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
  sunrise: (json['sunrise'] as List<dynamic>).map((e) => e as String).toList(),
  sunset: (json['sunset'] as List<dynamic>).map((e) => e as String).toList(),
  uvIndex: (json['uv_index_max'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
);

Map<String, dynamic> _$DailyBlockToJson(DailyBlock instance) =>
    <String, dynamic>{
      'time': instance.time,
      'weather_code': instance.weatherCode,
      'temperature_2m_max': instance.temperatureMax,
      'temperature_2m_min': instance.temperatureMin,
      'apparent_temperature_max': instance.apparentTemperatureMax,
      'apparent_temperature_min': instance.apparentTemperatureMin,
      'relative_humidity_2m_mean': instance.relativeHumidity,
      'surface_pressure_mean': instance.surfacePressure,
      'wind_speed_10m_max': instance.windSpeed,
      'precipitation_probability_max': instance.precipitationProbability,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'uv_index_max': instance.uvIndex,
    };

HourlyBlock _$HourlyBlockFromJson(Map<String, dynamic> json) => HourlyBlock(
  time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
  temperature: (json['temperature_2m'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  relativeHumidity: (json['relative_humidity_2m'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  apparentTemperature: (json['apparent_temperature'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  precipitationProbability: (json['precipitation_probability'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  weatherCode: (json['weather_code'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  windSpeed: (json['wind_speed_10m'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
  surfacePressure: (json['surface_pressure'] as List<dynamic>)
      .map((e) => e as num)
      .toList(),
);

Map<String, dynamic> _$HourlyBlockToJson(HourlyBlock instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.temperature,
      'relative_humidity_2m': instance.relativeHumidity,
      'apparent_temperature': instance.apparentTemperature,
      'precipitation_probability': instance.precipitationProbability,
      'weather_code': instance.weatherCode,
      'wind_speed_10m': instance.windSpeed,
      'surface_pressure': instance.surfacePressure,
    };
