import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:mobile/authentication/registration.dart';
import 'package:mobile/authentication/access_register_button.dart';
import 'package:mobile/authentication/input_field.dart';

import 'package:mobile/globals.dart' as globals;


class SimpleLoginScreen extends StatefulWidget {
  const SimpleLoginScreen({Key? key}) : super(key: key);
  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {

  late String username, password;
  String? usernameError, passwordError;

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";

    usernameError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      usernameError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    bool isValid = true;
    if (username.isEmpty) {
      setState(() {
        usernameError = "Username non valida";
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Password non valida";
      });
      isValid = false;
    }

    return isValid;
  }

  void setErrorText() {
    resetErrorText();
    setState(() {
      usernameError = "Username non valida";
      passwordError = "Password non valida";
    });
  }

  void openNavigation() {
    Navigator.pushNamed(context, '/userNavigationBar');
  }

  Future<void> fetchCredentials() async {
    final response = await http
        .post(
            Uri.parse('http://localhost:3001/auth/login'),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'username': username,
                'password': password,
            }),
        );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      globals.setUsername(username);
      openNavigation();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      setErrorText();
    } else {
      throw Exception('Failed to load login credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            const Image(image: AssetImage('res/Bologna.jpeg')),
            SizedBox(height: screenHeight * .05),
            const Text(
              "Benvenuto!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .02),
            const Text(
              "Accedi subito con le tue credenziali e scopri nuovi punti d'interesse a Bologna!",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * .08),
            InputField(
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              labelText: "Username",
              errorText: usernameError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              labelText: "Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: screenHeight * .025,
            ),
            FormButton(
              text: "Accedi",
              onPressed: () =>
              {
                fetchCredentials()
              }
            ),
            SizedBox(
              height: screenHeight * .05,
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SimpleRegisterScreen(),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  text: "oppure registrati cliccando ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "qui",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}