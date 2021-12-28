import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/sign_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth/components/background.dart';
import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

    final loginButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.lightBlue,
          onPrimary: Colors.black,
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text('Verifikasi Email', style: TextStyle(color: Colors.white)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final providerEmailSignUp =
                Provider.of<SignProvider>(context, listen: false);
            providerEmailSignUp.emailSignUp(emailController.text);

            _auth.sendPasswordResetEmail(email: emailController.text);
            Fluttertoast.showToast(
                msg: "Silahkan cek kotak masuk Email "
                    "anda untuk melanjutkan.");
          }
        });

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
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
                    "Ayo Gunakan Aplikasi \nmyHealth!",
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
                    "Masukkan email anda.",
                    style: TextStyle(
                      fontSize: 16,
                      color: kBlack,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                emailField,
                SizedBox(height: 20),
                loginButton,
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
