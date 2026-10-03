import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../app/features/features.dart';
import '../data/data.dart';

final getIt = GetIt.instance;
final talker = TalkerFlutter.init();
final dio = Dio();

/// Регистрация всех зависимостей приложения.
Future<void> setupLocator() async {
  setUpDio();

  // Логгер.
  getIt.registerSingleton(talker);

  // Репозитории.
  getIt.registerSingleton<ForecastRepositoryInterface>(
    ForecastRepository(dio: dio),
  );

  // Блоки экранов.
  getIt.registerSingleton(HomeBloc(getIt.get<ForecastRepositoryInterface>()));
  getIt.registerSingleton(
    DetailsBloc(getIt.get<ForecastRepositoryInterface>()),
  );
}
