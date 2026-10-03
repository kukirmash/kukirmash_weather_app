import 'daily_forecast.dart';

/// Интерфейс репозитория прогноза погоды.
///
/// Блоки зависят от интерфейса, а не от реализации, поэтому источник данных
/// (сеть, кэш, тестовый двойник) можно заменить без правок бизнес-логики.
abstract interface class ForecastRepositoryInterface {
  /// Первый запрос — список элементов: прогноз на несколько дней вперёд.
  Future<List<DailyForecast>> getWeekForecast();
}
