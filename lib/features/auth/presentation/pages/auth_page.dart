/*
  Auth Page - This page determines whether to show the login or register page
*/

import 'package:flutter/material.dart';
import 'package:vibe_in/features/auth/presentation/pages/register_page.dart';

import 'login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // initially, show login page

  bool showLoaginPage = true;

  // toggle between pages
  void togglePages() {
    setState(() {
      showLoaginPage = !showLoaginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoaginPage) {
      return LoginPage(togglePages: togglePages);
    } else {
      return RegisterPage(togglePages: togglePages);
    }
  }
}
