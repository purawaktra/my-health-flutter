import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/components/navigation_drawer.dart';

class ProfileScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final name = user.displayName!;
    final email = user.email!;
    final urlImage = user.photoURL!;
    var size = MediaQuery.of(context).size;

    return MaterialApp(
      home: DoubleBack(
          onFirstBackPress: (context) {
            final snackBar = SnackBar(
              content: Text('Press back again to exit',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Color(0xFFF8B501),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Scaffold(
            drawer: NavigationDrawerWidget(),
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/images/background_1.png",
                    width: size.width,
                  ),
                ),
                Scaffold(
                  drawer: NavigationDrawerWidget(),
                  body: Scaffold(
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
              ],
            ),
          )),
    );
  }
}
