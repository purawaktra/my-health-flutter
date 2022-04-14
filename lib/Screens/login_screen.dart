import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/forgot_password_screen.dart';
import 'package:myhealth/Screens/dashboard_screen.dart';
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
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black54,
        ),
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
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black54,
          ),
          suffixIcon: GestureDetector(
            onTap: _toggleObscured,
            child: Icon(
              _obscured
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: Colors.black54,
            ),
          ),
          hintText: "Password",
          border: InputBorder.none,
        ));

    final loginButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kLightBlue1,
          onPrimary: Colors.white,
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text('Masuk', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final snackBar = SnackBar(
              content: const Text("Sedang memuat...",
                  style: TextStyle(color: Colors.black)),
              backgroundColor: kYellow,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            final providerEmailLogin =
                Provider.of<SignProvider>(context, listen: false);
            String loginstate = await providerEmailLogin.emailLogin(
                emailController.text, passwordController.text);
            print(loginstate);

            if (loginstate == "true") {
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              } else {
                final snackBar = SnackBar(
                  content: const Text("'Fail to fetch data, cek koneksi anda!'",
                      style: TextStyle(color: Colors.black)),
                  backgroundColor: kYellow,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } else if (loginstate == "invalid-email") {
              final snackBar = SnackBar(
                content: const Text("Email atau password anda salah.",
                    style: TextStyle(color: Colors.black)),
                backgroundColor: kYellow,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (loginstate == "user-not-found") {
              final snackBar = SnackBar(
                content: const Text("Akun tidak terdaftar.",
                    style: TextStyle(color: Colors.black)),
                backgroundColor: kYellow,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (loginstate == "wrong-password") {
              final snackBar = SnackBar(
                content: const Text("Email atau password anda salah.",
                    style: TextStyle(color: Colors.black)),
                backgroundColor: kYellow,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (loginstate == "email-not-verified") {
              final snackBar = SnackBar(
                content: const Text("Link verifikasi email telah dikirim.",
                    style: TextStyle(color: Colors.black)),
                backgroundColor: kYellow,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        });

    Size size = MediaQuery.of(context).size;
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Spacer(),
                  Image.asset(
                    "assets/images/logo_app.png",
                    width: size.width * 0.35,
                    height: size.width * 0.35,
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
                          decoration: TextDecoration.none),
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
                            text: 'Lupa Password?',
                            style: TextStyle(
                                color: kBlack,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPasswordScreen();
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
      );
    }));
  }
}
