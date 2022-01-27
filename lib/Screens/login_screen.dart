import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/home_screen.dart';
import 'package:myhealth/Screens/welcome_screen.dart';
import 'package:myhealth/components/sign_method.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  late Stream _myStream;

  @override
  void initState() {
    super.initState();
    _myStream = FirebaseAuth.instance.authStateChanges();
  }

  bool _obscured = true;
  final textFieldFocusNode = FocusNode();

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon Masukkan Email Anda");
        }

        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Mohon Masukkan Email yang Valid");
        }

        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: "Email",
        border: InputBorder.none,
      ),
    );

    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: _obscured,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Kolom Password Masih Kosong");
          }
          if (!regex.hasMatch(value)) {
            return ('Password Terlalu Pendek');
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          suffixIcon: GestureDetector(
            onTap: _toggleObscured,
            child: Icon(
              _obscured
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
          ),
          hintText: "Password",
          border: InputBorder.none,
        ));

    final loginButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFF8B501),
        onPrimary: Colors.white,
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text('Masuk', style: TextStyle(color: Colors.white)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final providerEmailLogin =
              Provider.of<SignProvider>(context, listen: false);
          providerEmailLogin.emailLogin(
              emailController.text, passwordController.text);
        }
      },
    );

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: StreamBuilder(
      stream: _myStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return HomeScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Something Went Wrong!'),
          );
        } else {
          return MaterialApp(
              home: DoubleBack(
            onFirstBackPress: (context) {
              final snackBar =
                  SnackBar(content: Text('Press back again to exit'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Image.asset(
                        "assets/images/app_logo.png",
                        width: size.width * 0.35,
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Simpan Riwayat Medis Berhargamu di \nmyHealth!",
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
                      emailField,
                      passwordField,
                      SizedBox(height: 20),
                      loginButton,
                      SizedBox(height: 20),
                      Row(
                        children: [
                          RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Halaman Utama',
                                style: TextStyle(
                                    color: kBlack,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return WelcomeScreen();
                                      },
                                    ));
                                  },
                              ),
                            ],
                          )),
                          Spacer(),
                          RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Masuk dengan Google?',
                                style: TextStyle(
                                    color: kBlack,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    final providerGoogleLogin =
                                        Provider.of<SignProvider>(context,
                                            listen: false);
                                    providerGoogleLogin.googleLogin();
                                  },
                              ),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
        }
      },
    ));
  }
}
