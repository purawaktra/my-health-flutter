import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Welcome/components/background.dart';
import 'package:flutter_auth/components/google_sign_in.dart';
import 'package:flutter_auth/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
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
                "Haloo, \nSelamat Datang!",
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
                "Silahkan mendaftar untuk melanjutkan.",
                style: TextStyle(
                  fontSize: 16,
                  color: kBlack,
                ),

              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              icon: FaIcon(FontAwesomeIcons.envelope, color: Colors.white),
              label: Text(
                  'Daftar Dengan Email',
                  style: TextStyle(color: Colors.white)
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    )
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: Text('Daftar Dengan Google'),
              onPressed: () {
                final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              }
            ),
            SizedBox(height: 20),
            RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(color: kBlack,),
                    ),
                    TextSpan(
                        text: 'Masuk',
                        style: TextStyle(
                            color: kBlack,
                            decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()..onTap = (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                )
                            );
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
