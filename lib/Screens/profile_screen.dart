import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/navigation_drawer.dart';

class ProfileScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final name = user.displayName!;
    final email = user.email!;
    final urlImage = user.photoURL!;

    return MaterialApp(
      home: DoubleBack(
        onFirstBackPress: (context) {
          final snackBar = SnackBar(content: Text('Press back again to exit'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Scaffold(
          drawer: NavigationDrawerWidget(),
          body: Scaffold(
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
