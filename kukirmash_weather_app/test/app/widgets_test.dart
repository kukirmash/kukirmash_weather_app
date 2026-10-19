import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kukirmash_weather_app/app/app.dart';
import 'package:kukirmash_weather_app/data/data.dart';

import '../helpers/fixtures.dart';

void main() {
  testWidgets('WeatherCard показывает день и температуры', (tester) async {
    final day = sampleDay();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: WeatherCard(forecast: day, onTap: () {}),
          ),
        ),
      ),
    );

    expect(find.text('Пасмурно'), findsOneWidget);
    expect(find.text('12°'), findsOneWidget);
    expect(find.text('2°'), findsOneWidget);
    expect(find.byType(WeatherCard), findsOneWidget);
  });

  testWidgets('WeatherHeroCard показывает основные показатели', (tester) async {
    final day = sampleDay();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: WeatherHeroCard(forecast: day, eyebrow: 'Сегодня'),
          ),
        ),
      ),
    );

    expect(find.text('Сегодня'), findsOneWidget);
    expect(find.text('Пасмурно'), findsOneWidget);
    expect(find.text('61%'), findsOneWidget);
    expect(find.text('16 км/ч'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
  });

  testWidgets('MetricTile показывает значение и подпись', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SizedBox(
            width: 180,
            height: 116,
            child: MetricTile(
              icon: Icons.thermostat_rounded,
              label: 'Днём',
              value: '12°',
            ),
          ),
        ),
      ),
    );

    expect(find.text('12°'), findsOneWidget);
    expect(find.text('Днём'), findsOneWidget);
  });

  testWidgets('ForecastResponse парсит ответ и иконка дня доступна', (
    tester,
  ) async {
    final response = ForecastResponse.fromJson({
      'daily': {
        'time': ['2026-10-19'],
        'weather_code': [0],
        'temperature_2m_max': [15.0],
        'temperature_2m_min': [5.0],
        'apparent_temperature_max': [14.0],
        'apparent_temperature_min': [3.0],
        'relative_humidity_2m_mean': [40],
        'surface_pressure_mean': [1010.0],
        'wind_speed_10m_max': [7.0],
        'precipitation_probability_max': [0],
        'sunrise': ['2026-10-19T06:30'],
        'sunset': ['2026-10-19T16:40'],
        'uv_index_max': [1.0],
      },
    });

    final day = response.toDailyForecasts().single;
    expect(day.condition, WeatherCondition.clear);
    expect(day.imagePath, 'assets/images/sun.png');
  });
}
