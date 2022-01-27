import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/navigation_drawer.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    var size = MediaQuery.of(context).size;
    return MaterialApp(
      home: DoubleBack(
          onFirstBackPress: (context) {
            final snackBar =
                SnackBar(content: Text('Press back again to exit'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Scaffold(
              drawer: NavigationDrawerWidget(),
              body: Stack(
                children: <Widget>[
                  Container(
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image:
                                AssetImage("assets/images/home_screen_1.png"))),
                  ),
                  Container(
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
                ],
              ))),
    );
  }
}
