import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:module_business/module_business.dart';
import 'package:spendingtracker/blocs/authentication/authentication_bloc.dart';
import 'package:spendingtracker/main.dart';
import 'package:spendingtracker/ui/pages/pages.dart';
import 'package:spendingtracker/ui/scaffold_with_navigation/scaffold_with_nested_navigation.dart';

final _mainNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>();
final _shellNavigatorBKey = GlobalKey<NavigatorState>();

GoRouter goRouter(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: _mainNavigatorKey,
    debugLogDiagnostics: showDebug,
    redirect: ((context, state) {
      final currentLocation = state.fullPath;
      debugPrint("currentLocation $currentLocation");
      if (currentLocation != '/welcome' &&
          authenticationBloc.state is AuthenticationNone) {
        return '/welcome';
      }
      if (currentLocation != '/welcome' &&
          authenticationBloc.state is AuthenticationError) {
        return '/welcome';
      }
      if (currentLocation == '/welcome' &&
          authenticationBloc.state is AuthenticationSuccess) {
        return '/spending';
      }
      if (currentLocation == '/splash' &&
          authenticationBloc.state is AuthenticationSuccess) {
        return '/spending';
      }
      return null;
    }),
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) =>
            CustomTransitionPage<void>(
          key: state.pageKey,
          child: ScaffoldWithNestedNavigation(navigationShell: navigationShell),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAKey,
            routes: [
              GoRoute(
                path: '/spending',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CategoriesScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'category',
                    builder: (context, state) {
                      final category = state.extra as CategoryEntity;
                      return CategoryDetailScreen(category: category);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBKey,
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
