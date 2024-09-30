import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService
{
  GoogleAuthService._();
  static GoogleAuthService googleAuthService = GoogleAuthService._();

  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> singInWithGoogle()
  async {
    try {
      GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuthentication = await googleAccount!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    }catch(e)
    {
      Get.snackbar("Google Sign In Failed ",e.toString(),);
    }

  }
  Future<void> singOutFormGoogle()
  async {
   await googleSignIn.signOut();
  }
}