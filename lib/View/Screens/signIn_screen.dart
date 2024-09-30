import 'package:chat_app/Controller/auth_controller.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/google_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';


class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200,),
              TextField(
                controller: authController.txtEmail,
                decoration: InputDecoration(
                    label: Text('Email'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: authController.txtPassword,
                decoration: InputDecoration(
                    label: Text('Password'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed('/signUp');
                },
                child: Text('Dont have any Account ? '),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await AuthService.authService.signInWithUsingEmailandPassword(authController.txtEmail.text, authController.txtPassword.text);
                    User? user = AuthService.authService.getUser();
                    if (user != null) {
                      Get.offAndToNamed('/home');
                    } else {
                      Get.snackbar(
                          'Sign In Failed', 'Enter Proper Email and Password');
                    }
                  },
                  child: Text('Sign In')),
              SizedBox(
                height: 10,
              ),
              SignInButton(Buttons.google, onPressed: () async {
                await GoogleAuthService.googleAuthService.singInWithGoogle();
                User? user = AuthService.authService.getUser();
                if (user != null) {
                  Get.offAndToNamed('/home');
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
