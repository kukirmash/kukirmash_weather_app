import 'package:flutter/material.dart';

import '../../../../data/data.dart';
import '../../../theme/theme.dart';

/// Карточка часа в горизонтальном почасовом прогнозе.
class HourlyForecastTile extends StatelessWidget {
  const HourlyForecastTile({
    super.key,
    required this.forecast,
    this.highlighted = false,
  });

  final HourlyForecast forecast;

  /// Подсвечивает текущий час.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted
            ? ThemeColors.primary.withValues(alpha: 0.08)
            : ThemeColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlighted
              ? ThemeColors.primary.withValues(alpha: 0.35)
              : ThemeColors.line,
        ),
      ),
      child: Column(
        children: [
          Text(
            forecast.formattedTime,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: highlighted ? ThemeColors.primary : ThemeColors.muted,
            ),
          ),
          const Spacer(),
          Tooltip(
            message: forecast.conditionText,
            child: Image.asset(
              forecast.imagePath,
              width: 38,
              height: 38,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.cloud_rounded,
                size: 34,
                color: ThemeColors.primary,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${forecast.temperature.round()}°',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 11,
                color: ThemeColors.primaryLight.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 3),
              Text(
                '${forecast.precipitationProbability}%',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(letterSpacing: 0, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
