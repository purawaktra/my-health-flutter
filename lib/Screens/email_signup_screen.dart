import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/sign_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class EmailSignUpScreen extends StatefulWidget {
  const EmailSignUpScreen({Key? key}) : super(key: key);

  @override
  _EmailSignUpScreenState createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: kBlack),
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
          color: kBlack,
        ),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
      ),
    );

    final loginButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kLightBlue1,
          onPrimary: Colors.white,
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
    return DoubleBack(
      onFirstBackPress: (context) {
        final snackBar = SnackBar(
          content: Text('Press back again to exit',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xFFF8B501),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
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
                SizedBox(height: 20),
                emailField,
                SizedBox(height: 20),
                loginButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
