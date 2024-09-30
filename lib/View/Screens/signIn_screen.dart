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
      backgroundColor: const Color(0xff0d0603),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d0603),
        title: Text('Sign In',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 630,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100,),
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
          ],
        ),
      ),
    );
  }
}
