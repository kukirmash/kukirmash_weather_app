import 'package:flutter/material.dart';

import '../../../../data/data.dart';
import '../../../theme/theme.dart';

/// Текстовое описание дня и короткая рекомендация.
class DayDescriptionCard extends StatelessWidget {
  const DayDescriptionCard({super.key, required this.forecast});

  final DailyForecast forecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ThemeColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _description,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(height: 1.6, color: ThemeColors.ink),
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ThemeColors.softBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tips_and_updates_outlined,
                  size: 17,
                  color: ThemeColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _recommendation,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: ThemeColors.ink),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get _description {
    final buffer = StringBuffer()
      ..write(
        'Днём воздух прогреется до ${forecast.temperatureMax.round()}°, '
        'ночью температура опустится до ${forecast.temperatureMin.round()}°. '
        'Ощущается как ${forecast.apparentTemperatureMax.round()}°. ',
      )
      ..write(
        'Погода: ${forecast.conditionText.toLowerCase()}. '
        'Вероятность осадков — ${forecast.precipitationProbability}%, '
        'влажность воздуха — около ${forecast.relativeHumidity}%. ',
      )
      ..write(
        'Ветер до ${forecast.windSpeed.round()} км/ч, '
        'атмосферное давление — ${forecast.pressureMmHg.round()} мм рт. ст. ',
      )
      ..write(
        'Световой день продлится с ${forecast.formattedSunrise} '
        'до ${forecast.formattedSunset}, максимальный УФ-индекс — '
        '${forecast.uvIndex.toStringAsFixed(1)}.',
      );

    return buffer.toString();
  }

  String get _recommendation {
    final condition = forecast.condition;

    if (condition == WeatherCondition.thunderstorm ||
        condition == WeatherCondition.thunderstormHail) {
      return 'Лучше остаться в помещении: возможны гроза и сильные порывы '
          'ветра.';
    }
    if (condition == WeatherCondition.heavySnow ||
        condition == WeatherCondition.snow ||
        condition == WeatherCondition.snowShowers ||
        condition == WeatherCondition.snowGrains) {
      return 'На улице скользко. Выбирайте тёплую одежду и нескользящую обувь.';
    }
    if (condition.hasPrecipitation) {
      return 'Возьмите с собой зонт — в течение дня возможны осадки.';
    }
    if (forecast.uvIndex >= 6) {
      return 'Высокий УФ-индекс: используйте солнцезащитный крем и головной '
          'убор.';
    }
    if (forecast.temperatureMax <= 0) {
      return 'На улице морозно. Одевайтесь теплее и сократите время на '
          'открытом воздухе.';
    }
    if (forecast.temperatureMax >= 25) {
      return 'Тёплый день: пейте больше воды и избегайте долгого пребывания '
          'на солнце.';
    }
    return 'Хорошая погода для прогулки. Одевайтесь по сезону и наслаждайтесь '
        'днём.';
  }
}
