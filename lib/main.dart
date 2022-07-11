/*
  code imported from:
  Flutter UI
  ----------
  lib/screens/simple_login.dart
  lib/screens/persistent_tabs.dart
  lib/screens/ecommerce

  https://docs.flutter.dev/development/ui/widgets/material
*/

import 'package:flutter/material.dart';

import 'package:mobile/route_generator.dart';

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
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
  ));
}