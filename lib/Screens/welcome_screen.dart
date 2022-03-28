import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:myhealth/Screens/login_screen.dart';
import 'package:myhealth/Screens/email_signup_screen.dart';
import 'package:myhealth/Screens/onboarding_screen.dart';
import 'package:myhealth/components/sign_method.dart';
import 'package:myhealth/constants.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          if (FirebaseAuth.instance.currentUser != null) {
            return HomeScreen();
          }
          return Center(
            child: Text('Fail to fetch data, cek koneksi anda!'),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Unknown error, restart handphone anda!'),
          );
        } else {
          return OnboardingScreen();
        }
      },
    ));
  }
}
