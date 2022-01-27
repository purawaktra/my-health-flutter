import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/navigation_drawer.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen({
    Key? key,
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
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      );
}
