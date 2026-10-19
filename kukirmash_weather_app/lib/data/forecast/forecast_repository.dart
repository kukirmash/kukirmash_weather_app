import 'package:dio/dio.dart';

import '../endpoints.dart';
import 'daily_forecast.dart';
import 'day_details.dart';
import 'forecast_repository_interface.dart';
import 'forecast_response.dart';

/// Реализация репозитория прогноза погоды поверх HTTP-клиента Dio.
class ForecastRepository implements ForecastRepositoryInterface {
  ForecastRepository({required this.dio});

  final Dio dio;

  /// Запрашиваемые суточные показатели (список передаётся в API строкой).
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

  /// Запрашиваемые почасовые показатели.
  static final String _hourlyParameters = [
    'temperature_2m',
    'relative_humidity_2m',
    'apparent_temperature',
    'precipitation_probability',
    'weather_code',
    'wind_speed_10m',
    'surface_pressure',
  ].join(',');

  @override
  Future<List<DailyForecast>> getWeekForecast() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        Endpoints.forecast,
        queryParameters: {'daily': _dailyParameters, 'forecast_days': 7},
      );

      final data = response.data;
      if (data == null) {
        throw const ForecastException('Сервер вернул пустой ответ.');
      }

      final days = ForecastResponse.fromJson(data).toDailyForecasts();
      if (days.isEmpty) {
        throw const ForecastException('Сервер не прислал прогноз на неделю.');
      }
      return days;
    } on ForecastException {
      rethrow;
    } on DioException catch (exception) {
      throw ForecastException(_dioMessage(exception));
    } catch (_) {
      throw const ForecastException(
        'Не удалось обработать ответ сервера. Попробуйте ещё раз.',
      );
    }
  }

  @override
  Future<DayDetails> getDayDetails(String id) async {
    final date = DateTime.tryParse(id);
    if (date == null) {
      throw const ForecastException('Некорректная дата прогноза.');
    }

    final isoDate = date.toIso8601String().split('T').first;

    try {
      // Ограничиваем запрос одним днём — это и есть запрос элемента по id.
      final response = await dio.get<Map<String, dynamic>>(
        Endpoints.forecast,
        queryParameters: {
          'daily': _dailyParameters,
          'hourly': _hourlyParameters,
          'start_date': isoDate,
          'end_date': isoDate,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const ForecastException('Сервер вернул пустой ответ.');
      }

      final parsed = ForecastResponse.fromJson(data);
      final daily = parsed.toDailyForecasts();
      if (daily.isEmpty) {
        throw const ForecastException('Нет данных за выбранный день.');
      }

      return DayDetails(
        summary: daily.first,
        hourly: parsed.toHourlyForecasts(),
      );
    } on ForecastException {
      rethrow;
    } on DioException catch (exception) {
      throw ForecastException(_dioMessage(exception));
    } catch (_) {
      throw const ForecastException(
        'Не удалось обработать ответ сервера. Попробуйте ещё раз.',
      );
    }
  }

  /// Человеко-понятное описание сетевой ошибки.
  static String _dioMessage(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout =>
        'Сервер не ответил вовремя. Проверьте подключение и повторите попытку.',
      DioExceptionType.connectionError =>
        'Нет подключения к интернету. Проверьте сеть и повторите попытку.',
      DioExceptionType.badResponse =>
        'Сервер вернул ошибку ${exception.response?.statusCode ?? ''}. '
            'Попробуйте позже.',
      DioExceptionType.cancel => 'Запрос был отменён.',
      DioExceptionType.badCertificate || DioExceptionType.unknown =>
        'Не удалось загрузить прогноз погоды. Попробуйте ещё раз.',
    };
  }
}

/// Ошибка получения данных прогноза, показываемая пользователю.
class ForecastException implements Exception {
  const ForecastException(this.message);

  final String message;

  @override
  String toString() => message;
}
