import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../di/di.dart';
import '../features/features.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Верхнеуровневые переменные в Dart инициализируются лениво, поэтому
/// listenable создаётся при первом обращении к router (после setupLocator).
final GoRouter router = GoRouter(
  observers: [TalkerRouteObserver(talker)],
  debugLogDiagnostics: true,
  initialLocation: '/home',
  navigatorKey: _rootNavigationKey,
  refreshListenable: _AuthRefreshListenable(),
  redirect: _redirect,
  routes: [
    GoRoute(
      path: '/auth',
      pageBuilder: (_, state) =>
          MaterialPage(key: state.pageKey, child: const AuthScreen()),
    ),
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
    GoRoute(
      path: '/favorites',
      pageBuilder: (_, state) =>
          MaterialPage(key: state.pageKey, child: const FavoritesScreen()),
    ),
  ],
);

/// Не пускает неавторизованного пользователя дальше экрана входа.
String? _redirect(BuildContext context, GoRouterState state) {
  final authorized = getIt<AuthBloc>().state is AuthAuthenticated;
  final atAuthScreen = state.matchedLocation == '/auth';

  if (!authorized) return atAuthScreen ? null : '/auth';
  if (atAuthScreen) return '/home';
  return null;
}

/// Уведомляет GoRouter о каждом изменении состояния аутентификации,
/// чтобы переходы между экраном входа и приложением происходили сразу.
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable() {
    _subscription = getIt<AuthBloc>().stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
