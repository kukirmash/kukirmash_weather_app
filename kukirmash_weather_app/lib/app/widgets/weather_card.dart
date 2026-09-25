import 'package:flutter/material.dart';

/// Модель данных DailyWeather.
/// Добавлено поле imagePath для привязки конкретного изображения к состоянию погоды.
class DailyWeather {
  final String date;
  final String condition;
  final String imagePath;
  final int tempMorning;
  final int tempDay;
  final int tempEvening;
  final int tempFeelsLike;
  final int humidity;
  final int pressure;

  DailyWeather({
    required this.date,
    required this.condition,
    required this.imagePath,
    required this.tempMorning,
    required this.tempDay,
    required this.tempEvening,
    required this.tempFeelsLike,
    required this.humidity,
    required this.pressure,
  });
}

/// Пользовательский виджет WeatherCard.
class WeatherCard extends StatelessWidget {
  final DailyWeather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    const imageSize = 120.0;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: imageSize,
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Блок отображения иконки погоды
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                weather.imagePath,
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
            // Блок вывода текстовой информации
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Expanded(
                    child: Text(
                      '${weather.condition}\n'
                      'Утром: ${weather.tempMorning}°C | Днем: ${weather.tempDay}°C | Вечером: ${weather.tempEvening}°C\n'
                      'Ощущается как: ${weather.tempFeelsLike}°C\n'
                      'Влажность: ${weather.humidity}% | Давление: ${weather.pressure} мм',
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
