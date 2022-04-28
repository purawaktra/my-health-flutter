import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'navigation_drawer.dart';

class Background extends StatelessWidget {
  final Widget child;
  final Widget description;
  final String title;
  const Background({
    Key? key,
    required this.child,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavigationDrawerWidget(
        child: description,
      ),
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text(title),
      ),
      body: Stack(
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
            body: child,
            backgroundColor: Colors.transparent,
          )
        ],
      ),
    );
  }
}
