import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';

import 'di/di.dart';
import 'kukirmash_weather_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  // Логирование событий и состояний всех блоков приложения.
  Bloc.observer = TalkerBlocObserver(talker: talker);

  FlutterError.onError = (details) {
    return talker.handle(details.exception, details.stack);
  };

  runApp(const KukirmashWeatherApp());
}
