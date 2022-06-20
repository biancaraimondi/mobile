import 'package:flutter/material.dart';
import 'package:mobile/authentication/registration.dart';
import 'package:mobile/navigation/userNavigationBar.dart';

import '/authentication/formButton.dart';
import '/authentication/inputField.dart';

class SimpleLoginScreen extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (username, password)
  final Function(String? email, String? password)? onSubmitted;

  const SimpleLoginScreen({this.onSubmitted, Key? key}) : super(key: key);
  @override
  _SimpleLoginScreenState createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  late String username, password;
  String? usernameError, passwordError;
  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;

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

  void submit() {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(username, password);
      }
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
            /*
            SizedBox(height: screenHeight * .12),
            const Text(
              "Welcome,",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              "Sign in to continue!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
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
              onSubmitted: (val) => submit(),
              labelText: "Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            /*
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
             */
            SizedBox(
              height: screenHeight * .075,
            ),
            FormButton(
              text: "Accedi",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PersistentTabsDemo(),
                ),
              ),
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
                text: const TextSpan(
                  text: "oppure registrati cliccando ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "qui",
                      style: TextStyle(
                        color: Color(0xfff05454),
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