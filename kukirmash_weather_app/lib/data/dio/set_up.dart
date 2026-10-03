import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../di/di.dart';

/// Координаты и общие параметры запросов (город Чебоксары).
const double kLatitude = 56.13;
const double kLongitude = 47.25;

/// Настройка общего HTTP-клиента Dio.
///
/// Здесь задаются общая часть адресов запросов, постоянные query-параметры,
/// таймауты и перехватчик логирования.
void setUpDio() {
  // Общая часть адресов запросов.
  dio.options.baseUrl = 'https://api.open-meteo.com/v1';

  // Постоянные параметры: координаты точки и часовой пояс устройства.
  dio.options.queryParameters.addAll({
    'latitude': kLatitude,
    'longitude': kLongitude,
    'timezone': 'auto',
  });

  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);

  // Логирование запросов и ответов в talker.
  dio.interceptors.addAll([
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: true,
      ),
    ),
  ]);
}
