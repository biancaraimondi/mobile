import 'package:flutter/material.dart';

import 'package:mobile/authentication/login.dart';
import 'package:mobile/authentication/registration.dart';
import 'package:mobile/navigation/saved/user_pois.dart';
import 'package:mobile/navigation/user_navigation_bar.dart';
import 'package:mobile/navigation/explore/map.dart';

import 'navigation/saved/category_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SimpleLoginScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const SimpleLoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const SimpleRegisterScreen());
      case '/userNavigationBar':
        return MaterialPageRoute(builder: (_) => const PersistentTabsDemo());
      case '/explore':
        return MaterialPageRoute(builder: (_) => const Explore());
      case '/saved':
        return MaterialPageRoute(builder: (_) => const UserPOIs());
      case '/category':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => CategoryScreen(category: args));
        }
        else {
          return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  )
          );
        }
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