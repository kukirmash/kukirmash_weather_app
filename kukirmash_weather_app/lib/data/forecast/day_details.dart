import 'package:equatable/equatable.dart';

import 'daily_forecast.dart';
import 'hourly_forecast.dart';

/// Подробные данные одного дня: суточная сводка и почасовой прогноз.
///
/// Результат второго запроса — «отдельный элемент по id».
class DayDetails extends Equatable {
  const DayDetails({required this.summary, required this.hourly});

  /// Суточная сводка выбранного дня.
  final DailyForecast summary;

  /// Почасовой прогноз на этот же день (24 значения).
  final List<HourlyForecast> hourly;

  @override
  List<Object?> get props => [summary, hourly];
}
