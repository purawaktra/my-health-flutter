import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myhealth/Screens/welcome_screen.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/delete_data_screen.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscured = true;
  final textFieldFocusNode = FocusNode();
  final TextEditingController passwordController = new TextEditingController();
  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  bool isEnabled = false;

  enableDeleteAccountButton() {
    setState(() {
      isEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final providerdata = FirebaseAuth.instance.currentUser!.providerData.first;
    late GoogleSignInAccount? googleUser;

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Hapus Akun"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "\u2022 Entry tersimpan.",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "\u2022 Akses rekam medis partner.",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "\u2022 Akses anda ke partner.",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "\u2022 Akun dan informasi anda.",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
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
                      "Tidak ingin menghapus akun?",
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => DeleteDataScreen()));
                      },
                      child: Text(
                        "Hapus rekam medis dan partner",
                        style: TextStyle(color: kWhite),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kLightBlue1)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Builder(builder: (BuildContext context) {
                  String providerSelect = providerdata.providerId;
                  List<UserInfo> items = user.providerData;
                  for (UserInfo item in items) {
                    if (item.providerId == "password") {
                      providerSelect = item.providerId;
                    }
                  }
                  if (providerSelect == "password") {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Verifikasi akun anda untuk melanjutkan.",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        passwordField,
                        TapDebouncer(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                AuthCredential credential =
                                    EmailAuthProvider.credential(
                                        email: user.email!,
                                        password: passwordController.text);
                                await user
                                    .reauthenticateWithCredential(credential);
                                final snackBar = SnackBar(
                                  content: const Text("Verifikasi berhasil.",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: kYellow,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                enableDeleteAccountButton();
                              } on FirebaseAuthException catch (e) {
                                if (e.code == "wrong-password") {
                                  final snackBar = SnackBar(
                                    content: const Text("Password anda salah.",
                                        style: TextStyle(color: Colors.black)),
                                    backgroundColor: kYellow,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                return null;
                              }
                            }
                          },
                          builder:
                              (BuildContext context, TapDebouncerFunc? onTap) {
                            return ElevatedButton(
                              onPressed: onTap,
                              child: Text(
                                "Verifikasi",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          kLightBlue1)),
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                              googleUser = await googleSignIn.signIn();
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
                                    await googleUser!.authentication;

                                final credential =
                                    GoogleAuthProvider.credential(
                                  accessToken: googleAuth.accessToken,
                                  idToken: googleAuth.idToken,
                                );

                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);

                                enableDeleteAccountButton();

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
                      ],
                    );
                  }
                }),
                TapDebouncer(
                  onTap: () async {
                    try {
                      String uid = user.uid;
                      Reference ref = FirebaseStorage.instance
                          .ref()
                          .child('photo-profile')
                          .child('/' + uid);

                      try {
                        await ref.delete();
                      } catch (e) {
                        print(e.toString());
                      }
                      Reference ref2 = FirebaseStorage.instance
                          .ref()
                          .child('health-record-access')
                          .child('/' + uid);

                      try {
                        await ref2.delete();
                      } catch (e) {
                        print(e.toString());
                      }
                      final database = FirebaseDatabase.instance.ref();
                      await database.child("address" + uid).remove();
                      await database.child("birthdate" + uid).remove();
                      await database.child("birthplace" + uid).remove();
                      await database.child("city" + uid).remove();
                      await database.child("displayname" + uid).remove();
                      await database.child("email" + uid).remove();
                      await database.child("fullname" + uid).remove();
                      await database.child("gender" + uid).remove();
                      await database.child("job" + uid).remove();
                      await database.child("nik" + uid).remove();
                      await database.child("phonenumber" + uid).remove();
                      await database.child("photoprofile" + uid).remove();
                      await database.child("zipcode" + uid).remove();

                      DataSnapshot healthRecordRef =
                          await database.child("health-record" + uid).get();
                      for (DataSnapshot healthRecordItem
                          in healthRecordRef.children) {
                        for (DataSnapshot item in healthRecordItem.children) {
                          if (item.key.toString().startsWith("filename")) {
                            Reference healthRecordID = FirebaseStorage.instance
                                .ref()
                                .child('health-record')
                                .child(user.uid)
                                .child(healthRecordItem.key.toString())
                                .child(item.value.toString());
                            try {
                              await healthRecordID.delete();
                            } catch (e) {
                              print(e.toString());
                            }
                          }
                        }
                      }
                      await database.child("health-record/" + uid).remove();
                      await user.delete();

                      final snackBar = SnackBar(
                        content: const Text("Hapus akun berhasil.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                          (Route<dynamic> route) => false);
                    } catch (e) {
                      print(e.toString());
                      final snackBar = SnackBar(
                        content: const Text(
                            "Hapus akun gagal, muat ulang aplikasi.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  builder: (BuildContext context, TapDebouncerFunc? onTap) {
                    return ElevatedButton(
                      onPressed: isEnabled
                          ? onTap
                          : () {
                              final snackBar = SnackBar(
                                content: const Text(
                                    "Tindakan belum terverfikasi.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                      child: Text(
                        "Hapus akun",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
