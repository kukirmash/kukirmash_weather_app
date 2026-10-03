import 'package:flutter/material.dart';

import '../../data/data.dart';

/// Пользовательский виджет WeatherCard — карточка одного дня прогноза.
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.forecast, this.onTap});

  /// Данные дня прогноза, отображаемые в карточке.
  final DailyForecast forecast;

  /// Обработчик нажатия на карточку (переход на экран деталей).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const imageSize = 120.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: imageSize,
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Блок отображения иконки погоды.
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                forecast.imagePath,
                height: imageSize,
                width: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: imageSize,
                  width: imageSize,
                  color: Colors.grey[300],
                  child: const Icon(Icons.cloud, size: 50),
                ),
              ),
            ),
            // Блок вывода текстовой информации.
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    forecast.formattedDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Expanded(
                    child: Text(
                      '${forecast.conditionText}\n'
                      'Днём: ${forecast.temperatureMax.round()}°C | '
                      'Ночью: ${forecast.temperatureMin.round()}°C\n'
                      'Ощущается как: '
                      '${forecast.apparentTemperatureMax.round()}°C\n'
                      'Влажность: ${forecast.relativeHumidity}% | '
                      '${forecast.pressureMmHg.round()} мм',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
