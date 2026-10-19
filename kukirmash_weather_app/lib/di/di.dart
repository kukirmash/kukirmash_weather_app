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

  getIt.registerSingleton<Talker>(talker);

  getIt.registerLazySingleton<ForecastRepositoryInterface>(
    () => ForecastRepository(dio: dio),
  );

  // Блоки создаются на время жизни экрана и закрываются вместе с ним.
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<ForecastRepositoryInterface>()),
  );
  getIt.registerFactory<DetailsBloc>(
    () => DetailsBloc(getIt<ForecastRepositoryInterface>()),
  );
}
