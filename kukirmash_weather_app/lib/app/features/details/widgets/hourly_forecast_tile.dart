import 'package:flutter/material.dart';

import '../../../../data/data.dart';

/// Строка почасового прогноза на экране деталей.
class HourlyForecastTile extends StatelessWidget {
  const HourlyForecastTile({super.key, required this.forecast});

  /// Данные одного часа прогноза.
  final HourlyForecast forecast;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        SizedBox(
          width: 46,
          child: Text(
            forecast.formattedTime,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Image.asset(
          forecast.imagePath,
          width: 34,
          height: 34,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.cloud, size: 34),
        ),
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                forecast.conditionText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Влажность ${forecast.relativeHumidity}% · '
                'осадки ${forecast.precipitationProbability}%',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${forecast.temperature.round()}°C',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
