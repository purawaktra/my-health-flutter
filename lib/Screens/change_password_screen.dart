import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  bool _obscured = true;
  final _formKey = GlobalKey<FormState>();
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

  final TextEditingController oldPasswordController =
      new TextEditingController();
  final TextEditingController new1PasswordController =
      new TextEditingController();
  final TextEditingController new2PasswordController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final oldPasswordField = TextFormField(
        autofocus: false,
        controller: oldPasswordController,
        obscureText: _obscured,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty || !regex.hasMatch(value)) {
            return ("");
          }
          return null;
        },
        onSaved: (value) => oldPasswordController.text = value!,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_reset,
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
          hintStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
          labelText: "Kata sandi lama",
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorStyle: TextStyle(height: 0),
        ));

    final new1PasswordField = TextFormField(
        autofocus: false,
        controller: new1PasswordController,
        obscureText: _obscured,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');

          if (value!.isEmpty || !regex.hasMatch(value)) {
            return ("");
          }
          return null;
        },
        onSaved: (value) {
          new1PasswordController.text = value!;
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
          hintStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
          labelText: "Kata sandi baru",
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorStyle: TextStyle(height: 0),
        ));

    final new2PasswordField = TextFormField(
        autofocus: false,
        controller: new2PasswordController,
        obscureText: _obscured,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          RegExp regex2 = new RegExp(new1PasswordController.text);
          if (value!.isEmpty ||
              !regex.hasMatch(value) ||
              !regex2.hasMatch(value)) {
            return ("");
          }
          return null;
        },
        onSaved: (value) {
          new2PasswordController.text = value!;
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
          hintStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
          labelText: "Kata sandi baru",
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorStyle: TextStyle(height: 0),
        ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Ubah Kata Sandi"),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.document_scanner,
                        color: kLightBlue1,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Lupa password?",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final _auth = FirebaseAuth.instance;
                          try {
                            _auth.sendPasswordResetEmail(
                                email: user.email.toString());
                            final snackBar = SnackBar(
                              content: const Text("Email terkirim.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } catch (e) {
                            print(e);
                            final snackBar = SnackBar(
                              content: const Text("Error, silahkan muat ulang.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Text(
                          "Kirim email reset password",
                          style: TextStyle(color: kWhite),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kLightBlue1)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Proses ini akan menghapus:",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\u2022 Semua rekam medis.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "\u2022 Akses rekam medis partner",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "\u2022 Akses partner ke rekam medis anda.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "\u2022 Logout akun anda.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  oldPasswordField,
                  Divider(
                    color: Colors.black54,
                  ),
                  new1PasswordField,
                  new2PasswordField,
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: TapDebouncer(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final snackBar = SnackBar(
                            content: Text("Memuat...",
                                style: TextStyle(color: Colors.black)),
                            backgroundColor: kYellow,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: user.email.toString(),
                                  password: oldPasswordController.text)
                              .then((value) {
                            if (value.user != null) {
                              try {
                                value.user!
                                    .updatePassword(new2PasswordController.text)
                                    .whenComplete(() {
                                  final snackBar = SnackBar(
                                    content: Text("Ubah kata sandi berhasil.",
                                        style: TextStyle(color: Colors.black)),
                                    backgroundColor: kYellow,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.of(context).pop();
                                });
                              } on FirebaseAuthException catch (e) {
                                final snackBar = SnackBar(
                                  content: Text("Gagal, error code: ${e.code}",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: kYellow,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          }).catchError((e) {
                            print(e);
                            final snackBar = SnackBar(
                              content: Text("Gagal, kata sandi tidak sesuai.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      },
                      builder: (BuildContext context, TapDebouncerFunc? onTap) {
                        return ElevatedButton(
                          onPressed: onTap,
                          child: Text(
                            "Ubah Password",
                            style: TextStyle(color: kWhite),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  kLightBlue1)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
