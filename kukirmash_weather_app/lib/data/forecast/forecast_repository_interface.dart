import 'daily_forecast.dart';
import 'day_details.dart';

/// Контракт репозитория прогноза погоды.
///
/// Первый запрос возвращает список дней, второй — подробности одного дня по id.
abstract interface class ForecastRepositoryInterface {
  Future<List<DailyForecast>> getWeekForecast();

  Future<DayDetails> getDayDetails(String id);
}
