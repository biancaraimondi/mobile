/*
  code imported from:
  Flutter UI
  ----------
  lib/screens/simple_login.dart
  lib/screens/persistent_tabs.dart
*/

import 'package:flutter/material.dart';
import 'package:mobile/authentication/login.dart';
import 'package:mobile/navigation/userNavigationBar.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xfff05454),
          secondary: const Color(0xff30475e),
          brightness: Brightness.light
        ),
        //scaffoldBackgroundColor: const Color(0xfff05454),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),
      //home: const SimpleLoginScreen()
      home: const PersistentTabsDemo(),
      /*routes: {
        '/login': (context) => const SimpleLoginScreen(),
        '/userNavigationBar': (context) => Explore(),
      }*/
  ));
}

