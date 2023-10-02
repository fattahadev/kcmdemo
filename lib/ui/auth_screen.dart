import 'package:flutter/material.dart';
import 'package:kcmdemo/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Center(
        child: ElevatedButton(
          onPressed: () => authService.handleSignIn(),
          child: const Text('SignIn with google'),
        ),
      ),
    );
  }
}
