import 'package:kukirmash_weather_app/data/data.dart';

DailyForecast sampleDay({String id = '2026-10-19'}) {
  final date = DateTime.parse(id);
  return DailyForecast(
    id: id,
    date: date,
    weatherCode: 3,
    temperatureMax: 12,
    temperatureMin: 2,
    apparentTemperatureMax: 9.7,
    apparentTemperatureMin: -0.6,
    relativeHumidity: 61,
    surfacePressure: 1017,
    windSpeed: 15.9,
    precipitationProbability: 0,
    sunrise: DateTime(date.year, date.month, date.day, 6, 30),
    sunset: DateTime(date.year, date.month, date.day, 16, 40),
    uvIndex: 2.05,
  );
}

DayDetails sampleDetails({String id = '2026-10-19'}) {
  final date = DateTime.parse(id);
  return DayDetails(
    summary: sampleDay(id: id),
    hourly: [
      HourlyForecast(
        time: DateTime(date.year, date.month, date.day),
        temperature: 2.4,
        relativeHumidity: 88,
        apparentTemperature: -0.2,
        precipitationProbability: 0,
        weatherCode: 3,
        windSpeed: 4.2,
        surfacePressure: 1018,
      ),
      HourlyForecast(
        time: DateTime(date.year, date.month, date.day, 1),
        temperature: 2.1,
        relativeHumidity: 89,
        apparentTemperature: -0.5,
        precipitationProbability: 5,
        weatherCode: 2,
        windSpeed: 3.8,
        surfacePressure: 1018,
      ),
    ],
  );
}

class FakeForecastRepository implements ForecastRepositoryInterface {
  bool shouldFail = false;
  int weekCalls = 0;
  int detailsCalls = 0;

  @override
  Future<List<DailyForecast>> getWeekForecast() async {
    weekCalls++;
    if (shouldFail) {
      throw const ForecastException('Тестовая ошибка загрузки');
    }
    return [sampleDay()];
  }

  @override
  Future<DayDetails> getDayDetails(String id) async {
    detailsCalls++;
    if (shouldFail) {
      throw const ForecastException('Тестовая ошибка загрузки');
    }
    return sampleDetails(id: id);
  }
}
