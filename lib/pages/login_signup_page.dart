import 'package:flutter/material.dart';
import 'package:techassist_app/pages/login_page.dart';
import 'package:techassist_app/pages/register_page.dart';

class LoginOrSignUpPage extends StatefulWidget {
  const LoginOrSignUpPage({super.key});

  @override
  State<LoginOrSignUpPage> createState() => _LoginOrSignUpPageState();
}

class _LoginOrSignUpPageState extends State<LoginOrSignUpPage> {
  // initially show the login page
  bool showLoginPage = true;

  void tooglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: tooglePages);
    } else {
      return RegisterPage(onTap: tooglePages);
    }
  }
}
