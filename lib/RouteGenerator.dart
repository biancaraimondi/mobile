import 'package:flutter/material.dart';

import 'package:mobile/authentication/login.dart';
import 'package:mobile/navigation/userNavigationBar.dart';
import 'navigation/explore/map.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SimpleLoginScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const SimpleLoginScreen());
      case '/userNavigationBar':
        return MaterialPageRoute(builder: (_) => const PersistentTabsDemo());
      case '/explore':
        /*if (args is String) {
          return MaterialPageRoute(builder: (_) => const Explore());
        }*/
        return MaterialPageRoute(builder: (_) => const Explore());
      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                )
        );
    }
  }
}