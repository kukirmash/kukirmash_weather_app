import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../di/di.dart';
import '../features/features.dart';
import '../widgets/widgets.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  observers: [TalkerRouteObserver(talker)],
  debugLogDiagnostics: true,
  initialLocation: '/home',
  navigatorKey: _rootNavigationKey,
  routes: [
    GoRoute(
      path: '/home',
      pageBuilder: (_, state) =>
          MaterialPage(key: state.pageKey, child: const HomeScreen()),
    ),
    // Второй экран приложения. Выбранный день передаётся через extra.
    GoRoute(
      path: '/details',
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: DetailsScreen(weather: state.extra! as DailyWeather),
      ),
    ),
  ],
);
