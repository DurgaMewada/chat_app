import 'package:chat_app/Controller/auth_controller.dart';
import 'package:chat_app/Modal/user_modal.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: authController.txtName,
                decoration: InputDecoration(label: Text('Name'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: authController.txtEmail,
                decoration: InputDecoration(label: Text('Email'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: authController.txtPassword,
                decoration: InputDecoration(label: Text('Password'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: authController.txtConfirmPassword,
                decoration: InputDecoration(label: Text('Confirm Password'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: authController.txtPhone,
                decoration: InputDecoration(label: Text('Phone'),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextButton(onPressed: () {
                Get.toNamed('/');
              }, child: Text('Already have Account ?'),),
              SizedBox(height: 5,),
              ElevatedButton(onPressed: () async {
                if (authController.txtPassword.text ==
                    authController.txtConfirmPassword.text) {
                  await AuthService.authService
                      .createAccountUsingEmailandPassword(
                      authController.txtEmail.text,
                      authController.txtPassword.text);
                  UsersModal user = UsersModal(name: authController.txtName.text,
                      email: authController.txtEmail.text,
                      image: "https://i.pinimg.com/736x/4c/30/b9/4c30b9de7fe46ffb20d4ee4229509541.jpg",
                      phone: authController.txtPhone.text,
                      token: "");
                  CloudFireStoreService.cloudFireStoreService
                      .insertUserInFireStore(user);
                  Get.back();
                  authController.txtEmail.clear();
                  authController.txtPassword.clear();
                  authController.txtConfirmPassword.clear();
                  authController.txtPhone.clear();
                  authController.txtName.clear();
                }
              }, child: Text('Sign Up')),
            ],
          ),
        ),
      ),
    );
  }
}
