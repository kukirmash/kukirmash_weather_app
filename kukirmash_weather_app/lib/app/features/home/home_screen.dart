import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../../extensions/extensions.dart';

/// Главный экран приложения (HomeScreen).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Инициализация тестовых данных на 7 дней.
  final List<DailyWeather> weekForecast = [
    DailyWeather(
      date: '25 Сентября, Пт',
      condition: 'Облачно',
      imagePath: 'assets/images/cloud-sun.png',
      tempMorning: 12,
      tempDay: 15,
      tempEvening: 10,
      tempFeelsLike: 13,
      humidity: 60,
      pressure: 750,
    ),
    DailyWeather(
      date: '26 Сентября, Сб',
      condition: 'Ясно',
      imagePath: 'assets/images/sun.png',
      tempMorning: 10,
      tempDay: 18,
      tempEvening: 12,
      tempFeelsLike: 17,
      humidity: 55,
      pressure: 752,
    ),
    DailyWeather(
      date: '27 Сентября, Вс',
      condition: 'Кратковременный дождь',
      imagePath: 'assets/images/rain.png',
      tempMorning: 13,
      tempDay: 16,
      tempEvening: 11,
      tempFeelsLike: 14,
      humidity: 80,
      pressure: 748,
    ),
    DailyWeather(
      date: '28 Сентября, Пн',
      condition: 'Пасмурно',
      imagePath: 'assets/images/cloud-sun.png',
      tempMorning: 9,
      tempDay: 12,
      tempEvening: 8,
      tempFeelsLike: 9,
      humidity: 75,
      pressure: 745,
    ),
    DailyWeather(
      date: '29 Сентября, Вт',
      condition: 'Ясно',
      imagePath: 'assets/images/sun.png',
      tempMorning: 8,
      tempDay: 14,
      tempEvening: 9,
      tempFeelsLike: 12,
      humidity: 50,
      pressure: 755,
    ),
    DailyWeather(
      date: '30 Сентября, Ср',
      condition: 'Сильная гроза', // Изменил описание под картинку
      imagePath: 'assets/images/storm.png',
      tempMorning: 11,
      tempDay: 17,
      tempEvening: 12,
      tempFeelsLike: 16,
      humidity: 85,
      pressure: 735,
    ),
    DailyWeather(
      date: '1 Октября, Чт',
      condition: 'Дождь',
      imagePath: 'assets/images/rain.png',
      tempMorning: 10,
      tempDay: 13,
      tempEvening: 9,
      tempFeelsLike: 10,
      humidity: 90,
      pressure: 740,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Погода')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Прогноз на неделю',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: weekForecast.length,
              itemBuilder: (_, index) =>
                  WeatherCard(weather: weekForecast[index]),
              separatorBuilder: (_, __) => 16.ph,
            ),
          ],
        ),
      ),
    );
  }
}
