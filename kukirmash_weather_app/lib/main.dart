import 'package:flutter/material.dart';
import 'di/di.dart';
import 'kukirmash_weather_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  
  FlutterError.onError = (details) {
    return talker.handle(details.exception, details.stack);
  };
  
  runApp(const KukirmashWeatherApp());
}