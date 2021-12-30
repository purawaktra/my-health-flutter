import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/navigation_drawer.dart';
import 'package:flutter_auth/components/prevent_pop.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String urlImage;

  const ProfileScreen({
    Key? key,
    required this.name,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: DoubleBack(
          onFirstBackPress: (context) {
            final snackBar =
                SnackBar(content: Text('Press back again to exit'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Scaffold(
            body: Scaffold(
              drawer: NavigationDrawerWidget(),
              body: Scaffold(
                drawer: NavigationDrawerWidget(),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      );
}


