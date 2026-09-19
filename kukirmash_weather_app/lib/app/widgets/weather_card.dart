import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    const imageSize = 100.0;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: imageSize,
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/weather_icon.png', // Добавьте картинку с таким названием
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
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Чебоксары',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Expanded(
                    child: Text(
                      'Облачно, +15°C\nВетер 5 м/с\nВлажность 60%',
                      maxLines: 3,
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