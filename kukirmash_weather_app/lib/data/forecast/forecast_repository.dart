import 'package:dio/dio.dart';

import '../endpoints.dart';
import 'daily_forecast.dart';
import 'forecast_repository_interface.dart';
import 'forecast_response.dart';

/// Реализация репозитория прогноза погоды поверх HTTP-клиента Dio.
class ForecastRepository implements ForecastRepositoryInterface {
  ForecastRepository({required this.dio});

  final Dio dio;

  /// Запрашиваемые суточные показатели (список передаётся в API одной строкой).
  static final String _dailyParameters = [
    'weather_code',
    'temperature_2m_max',
    'temperature_2m_min',
    'apparent_temperature_max',
    'apparent_temperature_min',
    'relative_humidity_2m_mean',
    'surface_pressure_mean',
    'wind_speed_10m_max',
    'precipitation_probability_max',
    'sunrise',
    'sunset',
    'uv_index_max',
  ].join(',');

  @override
  Future<List<DailyForecast>> getWeekForecast() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        Endpoints.forecast,
        queryParameters: {
          'daily': _dailyParameters,
          'forecast_days': 7,
        },
      );
      final data = ForecastResponse.fromJson(response.data!);
      return data.toDailyForecasts();
    } on DioException catch (e) {
      throw ForecastException(
        e.message ?? 'Не удалось загрузить прогноз погоды',
      );
    }
  }
}

/// Ошибка получения данных прогноза, показываемая пользователю.
class ForecastException implements Exception {
  const ForecastException(this.message);

  final String message;

  @override
  String toString() => message;
}
