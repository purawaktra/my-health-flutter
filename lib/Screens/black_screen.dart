import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/components/navigation_drawer.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Background(
        child: Scaffold(
          drawer: NavigationDrawerWidget(),
          backgroundColor: Colors.white,
        ),
      ));
}
