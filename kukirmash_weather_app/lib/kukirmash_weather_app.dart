import 'package:flutter/material.dart';
import 'app/app.dart';

class KukirmashWeatherApp extends StatelessWidget {
  const KukirmashWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kukirmash Weather App',
      theme: AppTheme.lightTheme,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}