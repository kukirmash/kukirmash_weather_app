import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';
import '../../../di/di.dart';
import '../../extensions/extensions.dart';
import '../../features/favorites/favorites.dart';
import '../../widgets/widgets.dart';
import 'bloc/details_bloc.dart';
import 'widgets/hourly_forecast_tile.dart';
import 'widgets/metric_tile.dart';

/// Второй экран приложения (DetailsScreen).
///
/// Получает идентификатор дня и запрашивает по нему подробные данные.
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.id});

  /// Идентификатор дня — дата в формате ISO.
  final String id;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _details = getIt<DetailsBloc>();
  final _favorites = getIt<FavoritesBloc>();

  void loadDetails() => _details.add(DetailsLoad(id: widget.id));

  @override
  void initState() {
    loadDetails();
    // Подписка на избранное нужна, чтобы показать состояние закладки.
    if (_favorites.state is FavoritesInitial) {
      _favorites.add(const FavoritesStarted());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подробнее'),
        actions: [_buildFavoriteAction()],
      ),
      body: BlocBuilder<DetailsBloc, DetailsState>(
        bloc: _details,
        builder: (context, state) {
          return switch (state) {
            DetailsInitial() => const SizedBox.shrink(),
            DetailsLoadInProgress() => const AppProgressIndicator(),
            DetailsLoadSuccess() => _buildLoadSuccess(state),
            DetailsLoadFailure() => _buildLoadFailure(state),
          };
        },
      ),
    );
  }

  /// Кнопка добавления дня в избранное (Cloud Firestore).
  Widget _buildFavoriteAction() {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      bloc: _favorites,
      builder: (context, state) {
        final favorites = state is FavoritesLoadSuccess
            ? state.favorites
            : const <FavoriteDay>[];
        final favorite = favorites.any((day) => day.id == widget.id);

        return IconButton(
          tooltip: favorite
              ? 'Удалить из избранного'
              : 'Добавить в избранное',
          icon: Icon(
            favorite ? Icons.bookmark : Icons.bookmark_border,
          ),
          onPressed: favorite
              ? () => _favorites.add(
                  FavoriteRemoveRequested(id: widget.id),
                )
              : () {
                  final detailsState = _details.state;
                  if (detailsState is! DetailsLoadSuccess) return;
                  _favorites.add(
                    FavoriteAddRequested(
                      forecast: detailsState.details.summary,
                    ),
                  );
                },
        );
      },
    );
  }

  Widget _buildLoadSuccess(DetailsLoadSuccess state) {
    final summary = state.details.summary;
    final hourly = state.details.hourly;

    return RefreshIndicator(
      onRefresh: () {
        final completer = Completer();
        _details.add(DetailsLoad(id: widget.id, completer: completer));
        return completer.future;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Большое изображение состояния погоды.
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                summary.imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.cloud, size: 80),
                ),
              ),
            ),
            // Заголовок с датой и кратким описанием состояния.
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.formattedDate,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  summary.conditionText,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            _buildMetrics(summary),
            // Подробное текстовое описание дня.
            Text(
              _description(summary),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Почасовой прогноз',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: hourly.length,
              itemBuilder: (_, index) =>
                  HourlyForecastTile(forecast: hourly[index]),
              separatorBuilder: (_, _) => 12.ph,
            ),
          ],
        ),
      ),
    );
  }

  /// Сетка показателей выбранного дня (по две плитки в ряд).
  Widget _buildMetrics(DailyForecast summary) {
    final metrics = <({IconData icon, String label, String value})>[
      (
        icon: Icons.thermostat,
        label: 'Днём',
        value: '${summary.temperatureMax.round()}°C',
      ),
      (
        icon: Icons.nightlight_round,
        label: 'Ночью',
        value: '${summary.temperatureMin.round()}°C',
      ),
      (
        icon: Icons.device_thermostat,
        label: 'Ощущается',
        value: '${summary.apparentTemperatureMax.round()}°C',
      ),
      (
        icon: Icons.water_drop_outlined,
        label: 'Влажность',
        value: '${summary.relativeHumidity}%',
      ),
      (
        icon: Icons.speed,
        label: 'Давление',
        value: '${summary.pressureMmHg.round()} мм',
      ),
      (
        icon: Icons.air,
        label: 'Ветер',
        value: '${summary.windSpeed.round()} км/ч',
      ),
      (
        icon: Icons.grain,
        label: 'Осадки',
        value: '${summary.precipitationProbability}%',
      ),
      (
        icon: Icons.wb_sunny_outlined,
        label: 'УФ-индекс',
        value: summary.uvIndex.toStringAsFixed(1),
      ),
      (
        icon: Icons.wb_twilight,
        label: 'Восход',
        value: summary.formattedSunrise,
      ),
      (
        icon: Icons.nights_stay_outlined,
        label: 'Закат',
        value: summary.formattedSunset,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: tileWidth,
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

  Widget _buildLoadFailure(DetailsLoadFailure state) {
    return AppError(
      description: state.exception.toString(),
      onTap: loadDetails,
    );
  }

  /// Текст подробного описания дня, собираемый из полей модели.
  String _description(DailyForecast summary) =>
      'Температура воздуха днём поднимается до '
      '${summary.temperatureMax.round()}°C и опускается ночью до '
      '${summary.temperatureMin.round()}°C. С учётом скорости ветра и '
      'влажности температура ощущается как '
      '${summary.apparentTemperatureMax.round()}°C.\n\n'
      'Ожидается: ${summary.conditionText.toLowerCase()}. '
      'Вероятность осадков — ${summary.precipitationProbability}%, '
      'скорость ветра — до ${summary.windSpeed.round()} км/ч, '
      'влажность воздуха — около ${summary.relativeHumidity}%.\n\n'
      'Атмосферное давление составит ${summary.pressureMmHg.round()} мм рт. ст. '
      'Продолжительность светового дня: с ${summary.formattedSunrise} '
      'до ${summary.formattedSunset}, максимальный УФ-индекс — '
      '${summary.uvIndex.toStringAsFixed(1)}.\n\n'
      'Рекомендации: ${_recommendation(summary)}';

  /// Подбор рекомендации по состоянию погоды.
  String _recommendation(DailyForecast summary) {
    switch (summary.condition) {
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
