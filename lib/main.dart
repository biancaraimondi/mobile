/*
  code imported from:
  Flutter UI
  ----------
  lib/screens/simple_login.dart
  lib/screens/persistent_tabs.dart
*/

import 'package:flutter/material.dart';
import 'package:mobile/RouteGenerator.dart';
GlobalKey exploreKey = GlobalKey<NavigatorState>();
void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xfff05454),
          secondary: const Color(0xff30475e),
          brightness: Brightness.light
        ),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),
      //home: const SimpleLoginScreen()
      //home: const PersistentTabsDemo(),
      //initialRoute: '/login',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
          /*(routeSettings) {
          switch(routeSettings.name) {
            case '/login':
              return MaterialPageRoute(
                  settings: const RouteSettings(name: "/login"),
                  builder: (_) => const SimpleLoginScreen()
              );
            case '/explore':
              return MaterialPageRoute(
                settings: const RouteSettings(name: "/explore"),
                builder: (_) => const Explore(),
              );
          }
      }*/
      /*routes: {
        '/login': (context) => const SimpleLoginScreen(),
        '/explore': (context) => const Explore(),
      }*/
  ));
}

