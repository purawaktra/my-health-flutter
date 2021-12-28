import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/navigation_drawer.dart';
import 'package:flutter_auth/components/sign_method.dart';
import 'package:provider/provider.dart';

class LoggedInScreen extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Background(
        child: Scaffold(
          drawer: NavigationDrawerWidget(),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 32),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Name: ' + user.displayName!,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Email: ' + user.email!,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
