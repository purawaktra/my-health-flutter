import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/email_signup_screen.dart';
import 'package:myhealth/components/sign_method.dart';
import 'package:myhealth/constants.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        home: DoubleBack(
      onFirstBackPress: (context) {
        final snackBar = SnackBar(
          content: Text('Tekan kembali untuk keluar.',
              style: TextStyle(color: Colors.black)),
          backgroundColor: kYellow,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      background: const Color(0xFFF8B501),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Image.asset(
                    "assets/images/logo_app.png",
                    width: size.width * 0.35,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kLightBlue1,
                      onPrimary: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Daftar Dengan Email',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return EmailSignUpScreen();
                        },
                      ));
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: kLightBlue1,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Daftar Dengan Google',
                        style: TextStyle(
                          color: kBlack,
                        ),
                      ),
                      onPressed: () {
                        final provider =
                            Provider.of<SignProvider>(context, listen: false);
                        provider.googleLogin();
                      }),
                  SizedBox(height: 20),
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: TextStyle(
                          color: kBlack,
                        ),
                      ),
                      TextSpan(
                        text: 'Masuk',
                        style: TextStyle(
                            color: kBlack,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ));
                          },
                      ),
                    ],
                  )),
                ],
              ),
            ),
          )),
    ));
  }
}
