import 'package:flutter/material.dart';

import '../../data/data.dart';
import '../theme/theme.dart';

/// Карточка одного дня в списке на первом экране.
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.forecast, this.onTap});

  final DailyForecast forecast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemeColors.surface,
        borderRadius: radius,
        border: Border.all(color: ThemeColors.line),
      ),
      child: Material(
        color: ThemeColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThemeColors.softBlue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Hero(
                    tag: 'weather-${forecast.id}',
                    child: Image.asset(
                      forecast.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.cloud_rounded,
                        color: ThemeColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${forecast.relativeLabel(DateTime.now())} · '
                        '${forecast.shortFormattedDate}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        forecast.condition.shortDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${forecast.temperatureMax.round()}°',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${forecast.temperatureMin.round()}°',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: ThemeColors.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
