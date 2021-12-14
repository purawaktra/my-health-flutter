import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'generate.dart';

class SignProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }
  
  Future emailLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e){
      print(e.toString());
    }
    
    notifyListeners();
  }

  Future emailSignUp(String email) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, 
          password: generateRandomString(10));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(msg: "Email sudah digunakan!");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future logout() async {
    try {
      await googleSignIn.disconnect();
    } catch (e) {
      print(e.toString());
    }
    
    try {
      FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }

  }
}