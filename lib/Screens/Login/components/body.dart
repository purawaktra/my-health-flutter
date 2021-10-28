import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/google_sign_in.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/input_field.dart';
import 'package:flutter_auth/components/password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Image.asset(
              "assets/images/Asset 11@2x.png",
              width: size.width * 0.25,
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Simpan Data Medis Berhargamu di \nmyHealth!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Masukkan email dan password anda.",
                style: TextStyle(
                  fontSize: 16,
                  color: kBlack,
                ),
              ),
            ),
            SizedBox(height: 40),
            InputField(
              hintText: "Email",
              onChanged: (value) {},
            ),
            PasswordField(
                hintText: "Password"
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white)
              ),
              onPressed: () {},
            ),
            SizedBox(height: 20),
            RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Masuk dengan Google?',
                    style: TextStyle(
                        color: kBlack,
                        decoration: TextDecoration.underline
                    ),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      final provider =
                        Provider.of<GoogleSignInProvider>(context, listen: false);
                      provider.googleLogin();
                    },
                  ),
                ],
                )
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
