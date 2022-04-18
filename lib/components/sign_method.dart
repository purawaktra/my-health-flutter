import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<String> emailLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return e.code;
      // if (e.code == 'invalid-email') {
      //   SnackBar(content: const Text("Akun tidak terdaftar."));
      // } else if (e.code == 'user-not-found') {
      //   SnackBar(content: const Text("Akun tidak terdaftar."));
      // } else if (e.code == 'wrong-password') {
      //   SnackBar(content: const Text("Password salah."));
      // }
    } catch (e) {
      print(e.toString());
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;
      if (!user.emailVerified) {
        user.sendEmailVerification();
        await logout();
        return "email-not-verified";
      } else {
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
    return "true";
  }

  Future<String> emailSignUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
      // if (e.code == 'weak-password') {
      //   print(e.code);
      //   return e.code;
      // } else if (e.code == 'email-already-in-use') {
      //   print('The account already exists for that email.');
      //   Fluttertoast.showToast(msg: "Email sudah digunakan!");
      // }
    } catch (e) {
      print(e.toString());
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.updateDisplayName(
          RegExp(r"^([^@]+)").stringMatch(user.email.toString()).toString());
      await user.sendEmailVerification();
      await user.updatePhotoURL(
          "https://firebasestorage.googleapis.com/v0/b/myhealth-default-storage/o/blank_photo_profile.png?alt=media&token=b7c09a0d-cd6c-4514-9498-647b5df0bd28");
      await logout();
    } catch (e) {
      print(e.toString());
    }

    return "true";
  }

  Future<String> logout() async {
    String logoutcode = "true";
    try {
      await googleSignIn.disconnect();
    } catch (e) {
      print(e.toString());
      print("logout");

      try {
        FirebaseAuth.instance.signOut();
      } catch (e) {
        print(e.toString());
        print("logout");
        logoutcode = "false";
      }
    }

    return logoutcode;
  }
}
