import 'package:flutter/material.dart';

import '../../data/data.dart';
import '../theme/theme.dart';

/// Крупная карточка с основными показателями дня.
///
/// Используется на первом и втором экранах, чтобы интерфейс выглядел цельно.
class WeatherHeroCard extends StatelessWidget {
  const WeatherHeroCard({
    super.key,
    required this.forecast,
    required this.eyebrow,
    this.onTap,
  });

  final DailyForecast forecast;

  /// Короткая подпись над температурой: «Сегодня», «Завтра» и т. п.
  final String eyebrow;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(28);
    final softWhite = ThemeColors.white.withValues(alpha: 0.72);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF102E4A), Color(0xFF2B679F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102E4A).withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Material(
        color: ThemeColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                Positioned(
                  right: -70,
                  top: -80,
                  child: _Orb(size: 220, opacity: 0.055),
                ),
                Positioned(
                  left: -60,
                  bottom: -110,
                  child: _Orb(size: 240, opacity: 0.045),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: ThemeColors.white.withValues(
                                  alpha: 0.16,
                                ),
                              ),
                            ),
                            child: Text(
                              eyebrow,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ThemeColors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            forecast.formattedDate,
                            style: TextStyle(fontSize: 12, color: softWhite),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${forecast.temperatureMax.round()}°',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    height: 1,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -2.5,
                                    color: ThemeColors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  forecast.conditionText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.2,
                                    fontWeight: FontWeight.w600,
                                    color: ThemeColors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Ощущается как '
                                  '${forecast.apparentTemperatureMax.round()}°',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: softWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 108,
                            height: 108,
                            child: Hero(
                              tag: 'weather-${forecast.id}',
                              child: Image.asset(
                                forecast.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.cloud_rounded,
                                      size: 72,
                                      color: ThemeColors.white,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 1,
                        color: ThemeColors.white.withValues(alpha: 0.14),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _HeroMetric(
                              icon: Icons.water_drop_outlined,
                              text: '${forecast.relativeHumidity}%',
                            ),
                          ),
                          Expanded(
                            child: _HeroMetric(
                              icon: Icons.air_rounded,
                              text: '${forecast.windSpeed.round()} км/ч',
                            ),
                          ),
                          Expanded(
                            child: _HeroMetric(
                              icon: Icons.umbrella_outlined,
                              text: '${forecast.precipitationProbability}%',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: ThemeColors.white.withValues(alpha: 0.72)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ThemeColors.white.withValues(alpha: 0.86),
            ),
          ),
        ),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColors.white.withValues(alpha: opacity),
      ),
    );
  }
}
