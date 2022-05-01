import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myhealth/constants.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class AddEmailProviderScreen extends StatefulWidget {
  const AddEmailProviderScreen({Key? key}) : super(key: key);

  @override
  _AddEmailProviderScreenState createState() => _AddEmailProviderScreenState();
}

class _AddEmailProviderScreenState extends State<AddEmailProviderScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  bool _obscured = true;
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  late WhyFarther _selection;
  bool isEnabled = false;

  enableLinkButton() {
    setState(() {
      isEnabled = true;
    });
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  final TextEditingController new1PasswordController =
      new TextEditingController();
  final TextEditingController new2PasswordController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final new1PasswordField = TextFormField(
        autofocus: false,
        controller: new1PasswordController,
        obscureText: _obscured,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');

          if (value!.isEmpty) {
            return ("Masukkan kata sandi baru");
          }
          if (!regex.hasMatch(value)) {
            return ('Kata sandi terlalu pendek');
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
        ));

    final new2PasswordField = TextFormField(
        autofocus: false,
        controller: new2PasswordController,
        obscureText: _obscured,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          RegExp regex2 = new RegExp(new1PasswordController.text);
          if (value!.isEmpty) {
            return ("Masukkan kata sandi baru");
          }
          if (!regex.hasMatch(value)) {
            return ('Kata sandi terlalu pendek');
          }
          if (!regex2.hasMatch(value)) {
            return ('Kata sandi tidak sama');
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
        ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Tautkan Email"),
        actions: <Widget>[
          PopupMenuButton<WhyFarther>(
            onSelected: (WhyFarther result) {
              setState(() {
                _selection = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.harder,
                child: Text('Working a lot harder'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.smarter,
                child: Text('Being a lot smarter'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.selfStarter,
                child: Text('Being a self-starter'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.tradingCharter,
                child: Text('Placed in charge of trading charter'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.mark_email_read_outlined,
                            color: kLightBlue1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Menautkan email mengaktifkan:",
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
                                  "\u2022 Layanan login dengan email",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "\u2022 Export rekam medis.",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "\u2022 Export entry partner.",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Column(
                          children: [
                            Divider(
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Verifikasi akun anda untuk melanjutkan.",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TapDebouncer(
                        onTap: () async {
                          try {
                            final googleSignIn = GoogleSignIn();
                            var googleUser = await googleSignIn.signIn();
                            if (googleUser!.email != user.email) {
                              final snackBar = SnackBar(
                                content: const Text(
                                    "Email yang dipilih tidak sesuai.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              final googleAuth =
                                  await googleUser.authentication;

                              final credential = GoogleAuthProvider.credential(
                                accessToken: googleAuth.accessToken,
                                idToken: googleAuth.idToken,
                              );

                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);

                              enableLinkButton();

                              final snackBar = SnackBar(
                                content: const Text("Verifikasi berhasil.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } catch (e) {
                            final snackBar = SnackBar(
                              content: const Text(
                                  "Gagal untuk verifikasi akun.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        builder:
                            (BuildContext context, TapDebouncerFunc? onTap) {
                          return ElevatedButton(
                            onPressed: onTap,
                            child: Text(
                              "Masuk ke Google",
                              style: TextStyle(color: kWhite),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kLightBlue1)),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            Divider(
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      new1PasswordField,
                      new2PasswordField,
                      TapDebouncer(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            var credential = EmailAuthProvider.credential(
                                email: user.email.toString(),
                                password: new2PasswordController.text);
                            try {
                              await user.reload();
                              await user.linkWithCredential(credential);
                              final snackBar = SnackBar(
                                content: Text("Akun sudah tertaut.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.of(context).pop();
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
                        },
                        builder:
                            (BuildContext context, TapDebouncerFunc? onTap) {
                          return ElevatedButton(
                            onPressed: isEnabled
                                ? onTap
                                : () {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Tindakan belum terverfikasi.",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: kYellow,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                            child: Text(
                              "Tautkan",
                              style: TextStyle(color: kWhite),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kLightBlue1)),
                          );
                        },
                      )
                    ]),
              ))),
    );
  }
}
