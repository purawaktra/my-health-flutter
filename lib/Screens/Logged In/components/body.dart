import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/google_sign_in.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/input_field.dart';
import 'package:flutter_auth/components/password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    Size size = MediaQuery.of(context).size;
    return Background(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Logged In',
            style: TextStyle(color: Colors.white, fontSize: 24),),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.lightBlue,
          shadowColor: Colors.lightBlue,
          actions: [
            TextButton(
              child: Text('Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
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
              SizedBox(height: 8,),
              Text(
                'Name: ' + user.displayName!,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 8,),
              Text(
                'Email: ' + user.email!,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
          ],
        ),
        ),
      ),
    );
  }
}
