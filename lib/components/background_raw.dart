import 'package:flutter/material.dart';
import 'navigation_drawer.dart';

class BackgroundRaw extends StatelessWidget {
  final Widget child;
  const BackgroundRaw({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset(
            "assets/images/background_1.png",
            width: size.width,
            opacity: AlwaysStoppedAnimation<double>(1),
          ),
        ),
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: child,
          ),
          backgroundColor: Colors.transparent,
        )
      ],
    ));
  }
}
