import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Logged%20In/logged_in_widget.dart';
import 'package:flutter_auth/Screens/Welcome/components/body.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        } else if (snapshot.hasData){
          return LoggedInWidget();
        }else if (snapshot.hasError){
          return Center(child: Text('Something Went Wrong!'),);
        } else {
          return Body();
        }
      },
    )
  );
}
