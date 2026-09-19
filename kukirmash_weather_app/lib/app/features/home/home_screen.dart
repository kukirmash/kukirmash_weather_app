import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../extensions/extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            Text('Прогноз', style: Theme.of(context).textTheme.headlineLarge),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (_, __) => const WeatherCard(),
              separatorBuilder: (_, __) => 16.ph,
            ),
          ],
        ),
      ),
    );
  }
}