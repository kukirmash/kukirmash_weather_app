import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../di/di.dart';
import '../features/features.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Верхнеуровневые переменные в Dart инициализируются лениво, поэтому
/// router создаётся при первом обращении (после setupLocator).
final GoRouter router = GoRouter(
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
    GoRoute(
      path: '/details/:id',
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: DetailsScreen(id: state.pathParameters['id']!),
      ),
    ),
  ],
  errorBuilder: (context, state) =>
      _UnknownRouteScreen(location: state.uri.toString()),
);

/// Запасной экран для несуществующего маршрута.
class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Страница не найдена')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_off_outlined, size: 48),
              const SizedBox(height: 16),
              Text(
                'Маршрут $location не существует.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('На главный экран'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
