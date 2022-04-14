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
  final TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
        child: Text('Daftar', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          final snackBar = SnackBar(
            content: const Text("Sedang memuat...",
                style: TextStyle(color: Colors.black)),
            backgroundColor: kYellow,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          if (_formKey.currentState!.validate()) {
            final providerEmailSignUp =
                Provider.of<SignProvider>(context, listen: false);
            String emailstate = await providerEmailSignUp.emailSignUp(
                emailController.text, passwordController.text);
            print(emailstate);

            if (emailstate == "true") {
              final snackBar = SnackBar(
                content: const Text("Silahkan cek Email anda.",
                    style: TextStyle(color: Colors.black)),
                backgroundColor: kYellow,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (emailstate == "weak-password") {
              final snackBar = SnackBar(
                content: const Text("Password yang digunakan terlalu lemah.",
                    style: TextStyle(color: Colors.black)),
                backgroundColor: kYellow,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (emailstate.toString() == "email-already-in-use") {
              final snackBar = SnackBar(
                content: const Text("Email telah digunakan.",
                    style: TextStyle(color: Colors.black)),
                backgroundColor: kYellow,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
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
                          "Registrasi Akun",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kBlack,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pastikan email dan password telah benar. \nKami akan mengirimkan tautan verifikasi ke email anda.",
                          style: TextStyle(
                            fontSize: 16,
                            color: kBlack,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      emailField,
                      passwordField,
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
