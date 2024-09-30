import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/Services/auth_manger.dart';
import 'package:flutter/material.dart';




class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSR77HInJnycsaS2S55b4mnm_C6H9sEENMaw&s',
              height: screenHeight * 0.25,
              width: screenWidth * 0.5,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      splashTransition: SplashTransition.fadeTransition,
      nextScreen: AuthManager(),
      duration: 5000,
      splashIconSize: screenWidth * 0.8,
    );
  }
}