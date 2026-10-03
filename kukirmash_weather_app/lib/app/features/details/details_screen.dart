import 'package:flutter/material.dart';

import '../../../data/data.dart';

/// Второй экран приложения (DetailsScreen).
///
/// Отображает детальную информацию о выбранном дне прогноза.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.forecast});

  /// Выбранный день прогноза, по которому строится детальный экран.
  final DailyForecast forecast;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подробнее')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Большое изображение состояния погоды.
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                forecast.imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.cloud, size: 80),
                ),
              ),
            ),
            // Заголовок с датой и кратким описанием состояния.
            Text(
              forecast.formattedDate,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              forecast.conditionText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // Подробное описание: все показатели выбранного дня.
            Text(
              _description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// Текст подробного описания дня, собираемый из полей модели.
  String get _description =>
      'Температура воздуха днём поднимается до '
      '${forecast.temperatureMax.round()}°C и опускается ночью до '
      '${forecast.temperatureMin.round()}°C. С учётом скорости ветра и '
      'влажности температура ощущается как '
      '${forecast.apparentTemperatureMax.round()}°C.\n\n'
      'Ожидается: ${forecast.conditionText.toLowerCase()}.\n\n'
      'Относительная влажность воздуха составит около '
      '${forecast.relativeHumidity}%. Атмосферное давление — '
      '${forecast.pressureMmHg.round()} мм рт. ст. Скорость ветра — до '
      '${forecast.windSpeed.round()} км/ч. Вероятность осадков — '
      '${forecast.precipitationProbability}%.\n\n'
      'Восход: ${forecast.formattedSunrise}, закат: '
      '${forecast.formattedSunset}. УФ-индекс: '
      '${forecast.uvIndex.toStringAsFixed(1)}.\n\n'
      'Рекомендации: $_recommendation';

  /// Подбор рекомендации по состоянию погоды.
  String get _recommendation {
    switch (forecast.condition) {
      case WeatherCondition.clear:
      case WeatherCondition.mainlyClear:
        return 'погода располагает к длительной прогулке, не забудьте '
            'головной убор.';
      case WeatherCondition.lightRain:
      case WeatherCondition.rain:
      case WeatherCondition.heavyRain:
      case WeatherCondition.drizzle:
      case WeatherCondition.showers:
        return 'возьмите с собой зонт, возможны осадки.';
      case WeatherCondition.thunderstorm:
      case WeatherCondition.thunderstormHail:
        return 'лучше остаться в помещении, возможны порывы ветра и грозы.';
      case WeatherCondition.snow:
      case WeatherCondition.lightSnow:
      case WeatherCondition.heavySnow:
      case WeatherCondition.snowShowers:
      case WeatherCondition.snowGrains:
        return 'на улице скользко, выбирайте тёплую и нескользящую обувь.';
      default:
        return 'одевайтесь по погоде, день обещает быть прохладным.';
    }
  }
}
