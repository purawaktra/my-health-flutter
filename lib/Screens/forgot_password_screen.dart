import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          color: Colors.black54,
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
        child: Text('Reset Password', style: TextStyle(color: Colors.white)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _auth.sendPasswordResetEmail(email: emailController.text);
            final snackBar = SnackBar(
              content: const Text("Silahkan cek Email anda.",
                  style: TextStyle(color: Colors.black)),
              backgroundColor: kYellow,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Padding(
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
                          "Reset Email Password",
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
                          "Pastikan email yang anda ketik telah benar yaa. Kami akan mengirimkan link untuk mengatur ulang password anda ke email terdaftar.",
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
                      SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
