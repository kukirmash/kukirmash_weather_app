import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../app/features/features.dart';
import '../data/data.dart';

final getIt = GetIt.instance;
final talker = TalkerFlutter.init();
final dio = Dio();

/// Регистрация всех зависимостей приложения.
///
/// [firebaseAvailable] приходит из setUpFirebase(): на платформах, которые
/// FlutterFire не поддерживает (например, Linux), приложение продолжает
/// работать, а сервисы Firebase сообщают о недоступности.
Future<void> setupLocator({bool firebaseAvailable = false}) async {
  setUpDio();

  // Логгер.
  getIt.registerSingleton(talker);

  // Репозитории.
  getIt.registerSingleton<ForecastRepositoryInterface>(
    ForecastRepository(dio: dio),
  );
  getIt.registerSingleton<AuthRepositoryInterface>(
    AuthRepository(available: firebaseAvailable),
  );
  getIt.registerSingleton<FavoritesRepositoryInterface>(
    FavoritesRepository(available: firebaseAvailable),
  );

  // Блоки экранов.
  getIt.registerSingleton(HomeBloc(getIt.get<ForecastRepositoryInterface>()));
  getIt.registerSingleton(
    DetailsBloc(getIt.get<ForecastRepositoryInterface>()),
  );
  getIt.registerSingleton(AuthBloc(getIt.get<AuthRepositoryInterface>()));
  getIt.registerSingleton(
    FavoritesBloc(getIt.get<FavoritesRepositoryInterface>()),
  );
}
