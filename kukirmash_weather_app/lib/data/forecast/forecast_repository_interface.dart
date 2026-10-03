import 'daily_forecast.dart';
import 'day_details.dart';

/// Интерфейс репозитория прогноза погоды.
///
/// Блоки зависят от интерфейса, а не от реализации, поэтому источник данных
/// (сеть, кэш, тестовый двойник) можно заменить без правок бизнес-логики.
abstract interface class ForecastRepositoryInterface {
  /// Первый запрос — список элементов: прогноз на несколько дней вперёд.
  Future<List<DailyForecast>> getWeekForecast();

  /// Второй запрос — отдельный элемент по [id]: подробности одного дня.
  Future<DayDetails> getDayDetails(String id);
}
