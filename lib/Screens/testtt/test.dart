import 'package:flutter/material.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';

class TestDisek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 32, right: 32, top: 64, bottom: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: size.height * 0.1,
                  width: size.width,
                ),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.1),
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
