import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

/// Второй экран приложения (DetailsScreen).
///
/// Отображает детальную информацию о выбранном дне прогноза.
/// Данные приходят из первого экрана через параметр [weather].
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.weather});

  /// Выбранный день прогноза, по которому строится детальный экран.
  final DailyWeather weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подробнее')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Большое изображение состояния погоды.
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                weather.imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.cloud, size: 80),
                ),
              ),
            ),
            // Заголовок с датой и кратким описанием состояния.
            Text(
              weather.date,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              weather.condition,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // Подробное описание: все показатели выбранного дня.
            Text(
              _description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// Текст подробного описания дня, собираемый из полей модели.
  String get _description =>
      'Температура воздуха в течение дня меняется с ${weather.tempMorning}°C '
      'утром до ${weather.tempDay}°C днём и опускается до '
      '${weather.tempEvening}°C вечером. С учётом скорости ветра и влажности '
      'температура ощущается как ${weather.tempFeelsLike}°C.\n\n'
      'Ожидается: ${weather.condition.toLowerCase()}.\n\n'
      'Относительная влажность воздуха составит около ${weather.humidity}%. '
      'Атмосферное давление — ${weather.pressure} мм рт. ст.\n\n'
      'Рекомендации: $_recommendation';

  /// Подбор рекомендации по состоянию погоды.
  String get _recommendation {
    switch (weather.condition.toLowerCase()) {
      case 'ясно':
        return 'погода располагает к длительной прогулке, не забудьте головной убор.';
      case 'кратковременный дождь':
      case 'дождь':
        return 'возьмите с собой зонт, возможны кратковременные осадки.';
      case 'сильная гроза':
        return 'лучше остаться в помещении, возможны порывы ветра и грозы.';
      default:
        return 'одевайтесь по погоде, день обещает быть прохладным.';
    }
  }
}
