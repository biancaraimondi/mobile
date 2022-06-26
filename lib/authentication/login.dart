import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/authentication/registration.dart';
import 'package:http/http.dart' as http;

import '/authentication/access_register_button.dart';
import '/authentication/input_field.dart';

class SimpleLoginScreen extends StatefulWidget {

  //final Function(String? email, String? password)? onSubmitted;

  const SimpleLoginScreen({/*this.onSubmitted,*/ Key? key}) : super(key: key);
  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  late String username, password;
  String? usernameError, passwordError;
  //Function(String? email, String? password)? get onSubmitted => widget.onSubmitted;

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

  /*void submit() {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(username, password);
      }
    }
  }*/

  void setErrorText() {
    resetErrorText();
    setState(() {
      usernameError = "Username non valida";
      passwordError = "Password non valida";
    });
  }

  void openNavigation(String loginMsg) {
    if (loginMsg == 'Login failed') {
      setErrorText();
    } else {
      Navigator.pushNamed(context, '/userNavigationBar');
    }
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

    if (response.statusCode == 200) {
      return openNavigation(jsonDecode(response.body)['msg']);
    } else {
      throw Exception('Failed to load login credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const Image(image: AssetImage('res/aree_verdi.jpg')),
            /*
            SizedBox(height: screenHeight * .12),
            const Text(
              "Welcome,",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),*/
            SizedBox(height: screenHeight * .12),
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
              //onSubmitted: (val) => submit(),
              labelText: "Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: screenHeight * .075,
            ),
            FormButton(
              text: "Accedi",
              onPressed: () =>
              {
                fetchCredentials()
              }
            ),
            SizedBox(
              height: screenHeight * .15,
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