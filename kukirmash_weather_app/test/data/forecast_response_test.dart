import 'package:flutter_test/flutter_test.dart';
import 'package:kukirmash_weather_app/data/data.dart';

void main() {
  group('ForecastResponse', () {
    test('разбирает параллельные массивы Open-Meteo в модели', () {
      final response = ForecastResponse.fromJson({
        'daily': {
          'time': ['2026-10-19'],
          'weather_code': [3],
          'temperature_2m_max': [12.0],
          'temperature_2m_min': [2.0],
          'apparent_temperature_max': [9.7],
          'apparent_temperature_min': [-0.6],
          'relative_humidity_2m_mean': [61],
          'surface_pressure_mean': [1017.0],
          'wind_speed_10m_max': [15.9],
          'precipitation_probability_max': [0],
          'sunrise': ['2026-10-19T06:30'],
          'sunset': ['2026-10-19T16:40'],
          'uv_index_max': [2.05],
        },
        'hourly': {
          'time': ['2026-10-19T00:00', '2026-10-19T01:00'],
          'temperature_2m': [2.4, 2.1],
          'relative_humidity_2m': [88, 89],
          'apparent_temperature': [-0.2, -0.5],
          'precipitation_probability': [0, 5],
          'weather_code': [3, 2],
          'wind_speed_10m': [4.2, 3.8],
          'surface_pressure': [1018.0, 1018.0],
        },
      });

      final days = response.toDailyForecasts();
      final hours = response.toHourlyForecasts();

      expect(days, hasLength(1));
      expect(days.first.id, '2026-10-19');
      expect(days.first.formattedDate, '19 октября');
      expect(days.first.shortWeekday, 'Пн');
      expect(days.first.condition, WeatherCondition.overcast);
      expect(days.first.conditionText, 'Пасмурно');
      expect(days.first.pressureMmHg, closeTo(762.81, 0.01));

      expect(hours, hasLength(2));
      expect(hours.first.formattedTime, '00:00');
      expect(hours.last.formattedTime, '01:00');
      expect(hours.last.temperature, 2.1);
    });

    test('не падает при неполном ответе сервера', () {
      final response = ForecastResponse.fromJson({
        'daily': {
          'time': ['2026-10-19', '2026-10-20'],
          'weather_code': [3],
          'temperature_2m_max': [12.0],
          'temperature_2m_min': [2.0],
          'apparent_temperature_max': [9.7],
          'apparent_temperature_min': [-0.6],
          'relative_humidity_2m_mean': [61],
          'surface_pressure_mean': [1017.0],
          'wind_speed_10m_max': [15.9],
          'precipitation_probability_max': [0],
          'sunrise': ['2026-10-19T06:30'],
          'sunset': ['2026-10-19T16:40'],
          'uv_index_max': [2.05],
        },
      });

      expect(response.toDailyForecasts(), hasLength(1));
      expect(response.toHourlyForecasts(), isEmpty);
    });
  });

  group('DailyForecast', () {
    test('формирует относительные подписи дат', () {
      final day = DailyForecast(
        id: '2026-10-19',
        date: DateTime(2026, 10, 19),
        weatherCode: 0,
        temperatureMax: 12,
        temperatureMin: 2,
        apparentTemperatureMax: 10,
        apparentTemperatureMin: 1,
        relativeHumidity: 50,
        surfacePressure: 1013,
        windSpeed: 5,
        precipitationProbability: 0,
        sunrise: DateTime(2026, 10, 19, 6, 30),
        sunset: DateTime(2026, 10, 19, 16, 40),
        uvIndex: 2,
      );

      expect(day.relativeLabel(DateTime(2026, 10, 19, 12)), 'Сегодня');
      expect(day.relativeLabel(DateTime(2026, 10, 18, 12)), 'Завтра');
      expect(day.relativeLabel(DateTime(2026, 10, 17, 12)), 'Понедельник');
      expect(day.condition, WeatherCondition.clear);
    });
  });
}
