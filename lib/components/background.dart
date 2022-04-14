import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';

import 'navigation_drawer.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: kLightBlue1,
        ),
        body: DoubleBack(
          onFirstBackPress: (context) {
            final snackBar = SnackBar(
              content: Text('Tekan kembali untuk keluar.',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Color(0xFFF8B501),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Stack(
            children: <Widget>[
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   child: Image.asset(
              //     "assets/images/background_1.png",
              //     width: size.width,
              //     opacity: AlwaysStoppedAnimation<double>(1),
              //   ),
              // ),
              Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: child,
                ),
                backgroundColor: Colors.transparent,
              )
            ],
          ),
        ));
  }
}
