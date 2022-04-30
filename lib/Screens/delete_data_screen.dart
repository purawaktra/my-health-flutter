import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myhealth/Screens/welcome_screen.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class DeleteDataScreen extends StatefulWidget {
  const DeleteDataScreen({Key? key}) : super(key: key);

  @override
  _DeleteDataScreenState createState() => _DeleteDataScreenState();
}

class _DeleteDataScreenState extends State<DeleteDataScreen> {
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

    return Background(
      title: "Hapus Akun",
      description: Text("Deskripsi kosong."),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
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
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "\u2022 Entry tersimpan.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "\u2022 Akses rekam medis partner.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "\u2022 Akses anda ke partner.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "\u2022 Akun dan informasi anda.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
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
                      TapDebouncer(
                        onTap: () async {},
                        builder:
                            (BuildContext context, TapDebouncerFunc? onTap) {
                          return ElevatedButton(
                            onPressed: onTap,
                            child: Text(
                              "Hapus rekam medis dan entry",
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
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Builder(builder: (BuildContext context) {
                    print(providerdata.providerId);
                    if (providerdata.providerId == "password") {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Untuk memverifikasi tindakan anda, masukkan password yang anda gunakan pada kolom dibawah. ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          passwordField,
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                try {
                                  AuthCredential credential =
                                      EmailAuthProvider.credential(
                                          email: user.email!,
                                          password: passwordController.text);
                                  await user
                                      .reauthenticateWithCredential(credential);
                                } on FirebaseAuthException catch (e) {
                                  // TODO
                                  if (e.code == "wrong-password") {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Password anda salah.",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: kYellow,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  return null;
                                }
                                await user.updateDisplayName(RegExp(r"^([^@]+)")
                                    .stringMatch(user.email.toString())
                                    .toString());
                                await user.updatePhotoURL(
                                    "https://firebasestorage.googleapis.com/v0/b/myhealth-default-storage/o/blank_photo_profile.png?alt=media&token=b7c09a0d-cd6c-4514-9498-647b5df0bd28");

                                final database =
                                    FirebaseDatabase.instance.ref();
                                try {
                                  Reference ref = FirebaseStorage.instance
                                      .ref()
                                      .child('photo-profile')
                                      .child('/' + user.uid + '.jpg');
                                  await ref.delete();
                                } on Exception catch (e) {
                                  print(e);
                                }

                                try {
                                  await database.update({
                                    "nik/" + user.uid: "Kosong",
                                    "fullname/" + user.uid: "Kosong",
                                    "birthplace/" + user.uid: "Kosong",
                                    "birthdate/" + user.uid: "Kosong",
                                    "gender/" + user.uid: "Kosong",
                                    "address/" + user.uid: "Kosong",
                                    "city/" + user.uid: "Kosong",
                                    "zipcode/" + user.uid: "Kosong",
                                    "phonenumber/" + user.uid: "Kosong",
                                    "job/" + user.uid: "Kosong"
                                  });
                                } catch (e) {
                                  print(e.toString());
                                  final snackBar = SnackBar(
                                    content: const Text(
                                        "Reset data pribadi dan akun gagal, muat ulang aplikasi.",
                                        style: TextStyle(color: Colors.black)),
                                    backgroundColor: kYellow,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                final snackBar = SnackBar(
                                  content: const Text(
                                      "Reset data pribadi dan akun berhasil.",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: kYellow,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } catch (e) {
                                print(e.toString());
                                final snackBar = SnackBar(
                                  content: const Text(
                                      "Reset data pribadi dan akun gagal, muat ulang aplikasi.",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: kYellow,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Text(
                              "Reset Data Pribadi dan Akun",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                try {
                                  AuthCredential credential =
                                      EmailAuthProvider.credential(
                                          email: user.email!,
                                          password: passwordController.text);
                                  await user
                                      .reauthenticateWithCredential(credential);
                                } on FirebaseAuthException catch (e) {
                                  // TODO
                                  if (e.code == "wrong-password") {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Password anda salah.",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: kYellow,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  return null;
                                }

                                try {
                                  Reference ref = FirebaseStorage.instance
                                      .ref()
                                      .child('photo-profile')
                                      .child('/' + user.uid + '.jpg');
                                  await ref.delete();
                                } on Exception catch (e) {
                                  print(e);
                                }

                                try {
                                  final database =
                                      FirebaseDatabase.instance.ref();
                                  await database
                                      .child("nik/" + user.uid)
                                      .remove();
                                  await database
                                      .child("fullname/" + user.uid)
                                      .remove();
                                  await database
                                      .child("birthplace/" + user.uid)
                                      .remove();
                                  await database
                                      .child("birthdate/" + user.uid)
                                      .remove();
                                  await database
                                      .child("gender/" + user.uid)
                                      .remove();
                                  await database
                                      .child("address/" + user.uid)
                                      .remove();
                                  await database
                                      .child("city/" + user.uid)
                                      .remove();
                                  await database
                                      .child("zipcode/" + user.uid)
                                      .remove();
                                  await database
                                      .child("phonenumber/" + user.uid)
                                      .remove();
                                  await database
                                      .child("job/" + user.uid)
                                      .remove();
                                } catch (e) {
                                  print(e.toString());
                                  final snackBar = SnackBar(
                                    content: const Text(
                                        "Hapus data dan akun gagal, muat ulang aplikasi.",
                                        style: TextStyle(color: Colors.black)),
                                    backgroundColor: kYellow,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }

                                try {
                                  await user.delete();
                                } catch (e) {
                                  print(e.toString());
                                  final snackBar = SnackBar(
                                    content: const Text(
                                        "Hapus akun gagal, muat ulang aplikasi.",
                                        style: TextStyle(color: Colors.black)),
                                    backgroundColor: kYellow,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }

                                final snackBar = SnackBar(
                                  content: const Text(
                                      "Hapus data dan akun berhasil.",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: kYellow,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()),
                                    (Route<dynamic> route) => false);
                              } catch (e) {
                                print(e.toString());
                                final snackBar = SnackBar(
                                  content: const Text(
                                      "Hapus data dan akun gagal, muat ulang aplikasi.",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: kYellow,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Text(
                              "Hapus Data dan Akun",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)),
                          )
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Verifikasi akun anda untuk melanjutkan.",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
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
                            builder: (BuildContext context,
                                TapDebouncerFunc? onTap) {
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
                          TapDebouncer(
                            onTap: () async {
                              Reference ref = FirebaseStorage.instance
                                  .ref()
                                  .child('photo-profile')
                                  .child('/' + user.uid + '.jpg');
                              final database = FirebaseDatabase.instance.ref();
                              await database.child("nik/" + user.uid).remove();
                              await database
                                  .child("fullname/" + user.uid)
                                  .remove();
                              await database
                                  .child("birthplace/" + user.uid)
                                  .remove();
                              await database
                                  .child("birthdate/" + user.uid)
                                  .remove();
                              await database
                                  .child("gender/" + user.uid)
                                  .remove();
                              await database
                                  .child("address/" + user.uid)
                                  .remove();
                              await database.child("city/" + user.uid).remove();
                              await database
                                  .child("zipcode/" + user.uid)
                                  .remove();
                              await database
                                  .child("phonenumber/" + user.uid)
                                  .remove();
                              await database.child("job/" + user.uid).remove();
                              try {
                                await ref.delete();
                              } catch (e) {
                                print(e.toString());
                              }
                              try {
                                await user.delete();
                                final snackBar = SnackBar(
                                  content: const Text("Hapus akun berhasil.",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: kYellow,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            builder: (BuildContext context,
                                TapDebouncerFunc? onTap) {
                              return ElevatedButton(
                                onPressed: isEnabled
                                    ? onTap
                                    : () {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Tindakan belum terverfikasi.",
                                              style: TextStyle(
                                                  color: Colors.black)),
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
                                        MaterialStateProperty.all<Color>(
                                            Colors.red)),
                              );
                            },
                          )
                        ],
                      );
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
