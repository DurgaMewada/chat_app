
import 'package:flutter/material.dart';

import '../View/Screens/home_screen.dart';
import '../View/Screens/signIn_screen.dart';
import 'auth_services.dart';




class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    return (AuthService.authService.getUser() == null)
        ?  SignIn()
        :  HomeScreen();
  }
}