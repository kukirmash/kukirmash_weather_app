import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/data.dart';
import '../../../di/di.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import 'bloc/details_bloc.dart';
import 'widgets/day_description_card.dart';
import 'widgets/hourly_forecast_tile.dart';
import 'widgets/metric_tile.dart';

/// Второй экран — подробный прогноз выбранного дня.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.id});

  /// Идентификатор дня — дата в формате ISO.
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DetailsBloc>()..add(DetailsLoadRequested(id: id)),
      child: _DetailsView(id: id),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: ThemeColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: ThemeColors.line),
                    ),
                    child: IconButton(
                      tooltip: 'Назад',
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: ThemeColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Детали прогноза',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          return switch (state) {
            DetailsInitial() || DetailsLoading() => const AppLoading(
              message: 'Загружаем подробности',
            ),
            DetailsError(:final exception) => AppError(
              message: exception.toString(),
              onRetry: () =>
                  context.read<DetailsBloc>().add(DetailsLoadRequested(id: id)),
            ),
            DetailsLoaded(:final details, :final refreshError) =>
              _DetailsContent(details: details, refreshError: refreshError),
          };
        },
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent({required this.details, this.refreshError});

  final DayDetails details;
  final Object? refreshError;

  @override
  Widget build(BuildContext context) {
    final summary = details.summary;
    final hourly = details.hourly;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: RefreshIndicator(
          color: ThemeColors.primary,
          onRefresh: () => _refresh(context),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 36),
            children: [
              if (refreshError != null) ...[
                const RefreshNotice(),
                const SizedBox(height: 12),
              ],
              WeatherHeroCard(
                forecast: summary,
                eyebrow: summary.relativeLabel(DateTime.now()),
              ),
              const SizedBox(height: 28),
              const SectionTitle(title: 'Показатели'),
              const SizedBox(height: 12),
              _MetricsGrid(forecast: summary),
              const SizedBox(height: 28),
              SectionTitle(
                title: 'Почасовой прогноз',
                trailing: hourly.isEmpty ? null : '${hourly.length} ч',
              ),
              const SizedBox(height: 12),
              if (hourly.isEmpty)
                _EmptyHourly()
              else
                SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    itemCount: hourly.length,
                    itemBuilder: (context, index) {
                      final item = hourly[index];
                      return HourlyForecastTile(
                        forecast: item,
                        highlighted: _isCurrentHour(item.time),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                  ),
                ),
              const SizedBox(height: 28),
              const SectionTitle(title: 'О дне'),
              const SizedBox(height: 12),
              DayDescriptionCard(forecast: summary),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) {
    final completer = Completer<void>();
    context.read<DetailsBloc>().add(
      DetailsLoadRequested(id: id, completer: completer),
    );
    return completer.future;
  }

  String get id => details.summary.id;

  static bool _isCurrentHour(DateTime value) {
    final now = DateTime.now();
    return value.year == now.year &&
        value.month == now.month &&
        value.day == now.day &&
        value.hour == now.hour;
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.forecast});

  final DailyForecast forecast;

  @override
  Widget build(BuildContext context) {
    final metrics = <({IconData icon, String label, String value})>[
      (
        icon: Icons.thermostat_rounded,
        label: 'Днём',
        value: '${forecast.temperatureMax.round()}°',
      ),
      (
        icon: Icons.nightlight_outlined,
        label: 'Ночью',
        value: '${forecast.temperatureMin.round()}°',
      ),
      (
        icon: Icons.device_thermostat_rounded,
        label: 'Ощущается днём',
        value: '${forecast.apparentTemperatureMax.round()}°',
      ),
      (
        icon: Icons.water_drop_outlined,
        label: 'Влажность',
        value: '${forecast.relativeHumidity}%',
      ),
      (
        icon: Icons.air_rounded,
        label: 'Ветер',
        value: '${forecast.windSpeed.round()} км/ч',
      ),
      (
        icon: Icons.speed_rounded,
        label: 'Давление',
        value: '${forecast.pressureMmHg.round()} мм',
      ),
      (
        icon: Icons.umbrella_outlined,
        label: 'Осадки',
        value: '${forecast.precipitationProbability}%',
      ),
      (
        icon: Icons.wb_sunny_outlined,
        label: 'УФ-индекс',
        value: forecast.uvIndex.toStringAsFixed(1),
      ),
      (
        icon: Icons.wb_twilight_rounded,
        label: 'Восход',
        value: forecast.formattedSunrise,
      ),
      (
        icon: Icons.bedtime_outlined,
        label: 'Закат',
        value: forecast.formattedSunset,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620 ? 3 : 2;
        const spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: width,
                height: 116,
                child: MetricTile(
                  icon: metric.icon,
                  label: metric.label,
                  value: metric.value,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EmptyHourly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ThemeColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ThemeColors.line),
      ),
      child: Text(
        'Почасовые данные для этого дня недоступны.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
