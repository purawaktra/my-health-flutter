import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/background.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final name = user.displayName!;
    final email = user.email!;
    final urlImage = user.photoURL!;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Profile",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            SizedBox(height: 32),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(urlImage),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Name: ' + name,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Email: ' + email,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
