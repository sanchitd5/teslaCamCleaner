import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
export 'package:go_router/go_router.dart';

import '../../screens/screens.dart';
import '../../models/models.dart';

class RouterTemplate {}

class ParentRouter {
  late final GoRouter router;

  RouteConfig defaultRoute = RouteConfig(
    route: WelcomePage.route,
    type: RouteType.UN_AUTHENTICATED,
    widget: WelcomePage(),
  );

  List<RouteConfig> extraRoutes = [];

  Widget Function(Widget screen) authWidget = (Widget screen) {
    return screen;
  };

  final List<RouteConfig> _routes = [
    RouteConfig(
      route: Login.route,
      type: RouteType.UN_AUTHENTICATED,
      widget: Login(),
    ),
    RouteConfig(
      route: SignUp.route,
      type: RouteType.UN_AUTHENTICATED,
      widget: const SignUp(),
    ),
    RouteConfig(
      route: Home.route,
      type: RouteType.AUTHENTICATED,
      widget: const Home(),
    ),
    RouteConfig(
      route: ChangePassword.route,
      type: RouteType.AUTHENTICATED,
      widget: const ChangePassword(),
    ),
    RouteConfig(
      route: DevEnvironment.route,
      type: RouteType.AUTHENTICATED,
      widget: const DevEnvironment(),
    ),
  ];

  void initialize() {
    if (extraRoutes.isNotEmpty) {
      _routes.addAll(extraRoutes);
    }
    _routes.add(defaultRoute);
    router = GoRouter(
      initialLocation: defaultRoute.route,
      routes: _routes.map((route) {
        return GoRoute(
            path: route.route,
            pageBuilder: (context, state) {
              if (route.type == RouteType.AUTHENTICATED) {
                return MaterialPage(child: authWidget(route.widget));
              }
              return MaterialPage(child: route.widget);
            });
      }).toList(),
      errorBuilder: (context, state) {
        return const Four0Four(
          isInitialLoading: true,
          redirectionDuration: Duration(milliseconds: 1000),
        );
      },
    );
  }

  GoRouter get appRouter => router;

  List<RouteConfig> get routes => _routes;
}
