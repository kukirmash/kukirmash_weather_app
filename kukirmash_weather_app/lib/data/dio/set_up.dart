import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../di/di.dart';

/// Координаты точки прогноза — город Чебоксары.
const double kLatitude = 56.13;
const double kLongitude = 47.25;

/// Настройка общего HTTP-клиента Dio.
///
/// Здесь задаются общая часть адресов запросов, постоянные query-параметры,
/// таймауты и перехватчик логирования.
void setUpDio() {
  dio.options
    ..baseUrl = 'https://api.open-meteo.com/v1'
    ..connectTimeout = const Duration(seconds: 10)
    ..receiveTimeout = const Duration(seconds: 15)
    ..queryParameters.addAll({
      'latitude': kLatitude,
      'longitude': kLongitude,
      // Open-Meteo сам определяет часовой пояс по координатам.
      'timezone': 'auto',
    });

  // Логирование запросов и ответов в talker.
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: true,
      ),
    ),
  );
}
