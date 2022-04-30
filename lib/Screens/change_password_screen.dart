import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  late WhyFarther _selection;
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
          if (value!.isEmpty) {
            return ("Masukkan kata sandi lama");
          }
          if (!regex.hasMatch(value)) {
            return ('Kata sandi terlalu pendek');
          }
          return null;
        },
        onSaved: (value) => oldPasswordController.text = value!,
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
          labelText: "Kata sandi lama",
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ));

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
        title: Text("Ubah Kata Sandi"),
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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  oldPasswordField,
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
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
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: TapDebouncer(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: user.email.toString(),
                                  password: new2PasswordController.text)
                              .then((value) {
                            if (value.user != null) {
                              final snackBar = SnackBar(
                                content: const Text("Verifikasi berhasil.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }).catchError((e) {
                            print(e);
                            final snackBar = SnackBar(
                              content: const Text(
                                  "Gagal, password tidak sesuai.",
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
