import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static AuthService authService = AuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ACCOUNT CREATE
  Future<void> createAccountUsingEmailandPassword(String email, String password )
  async {
   await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

 // LOGIN SIGN IN
  Future<void> signInWithUsingEmailandPassword(String email ,String password)
   async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // SIGN OUT
  Future<void> signOutUser()
  async {
    await _firebaseAuth.signOut();
  }

  // GET CREATE USER
   User? getUser()
   {
     User? user = _firebaseAuth.currentUser;
     if(user!=null)
       {
          log("Email = ${user.email}");

       }
     return user;
   }


}
