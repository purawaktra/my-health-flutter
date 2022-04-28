import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myhealth/Screens/welcome_screen.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreen createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final providerdata = FirebaseAuth.instance.currentUser!.providerData.first;

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
      title: "Informasi dan Pengaturan",
      description: Text("Deskripsi kosong."),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      user.displayName!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      user.uid,
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                    Divider(
                      color: kDarkBlue,
                    ),
                    Text(
                      "\"Reset Data Pribadi dan Akun\" akan menghapus seluruh informasi pribadi dan rekam medis tertaut, serta mengembalikan akun seperti sesaat setelah registrasi dilakukan.",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "\"Hapus Data dan Akun\" akan menutup akun serta menghapus rekam medis tertaut. Anda akan terlogout dan kembali ke halaman awal aplikasi.",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 8,
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
                                    await user.reauthenticateWithCredential(
                                        credential);
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
                                  await user.updateDisplayName(
                                      RegExp(r"^([^@]+)")
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
                                          style:
                                              TextStyle(color: Colors.black)),
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
                                    await user.reauthenticateWithCredential(
                                        credential);
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
                                          style:
                                              TextStyle(color: Colors.black)),
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
                                          style:
                                              TextStyle(color: Colors.black)),
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
                                          builder: (context) =>
                                              WelcomeScreen()),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Untuk memverifikasi tindakan anda, setelah menekan tombol, anda akan ditampilkan pilihan login dengan akun Google, silahkan pilih akun google yang sesuai dengan akun yang digunakan. ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  final googleSignIn = GoogleSignIn();
                                  final googleUser =
                                      await googleSignIn.signIn();
                                  if (googleUser!.email != user.email) {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Email yang dipilih tidak sesuai.",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: kYellow,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    final googleAuth =
                                        await googleUser.authentication;

                                    final credential =
                                        GoogleAuthProvider.credential(
                                      accessToken: googleAuth.accessToken,
                                      idToken: googleAuth.idToken,
                                    );

                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);

                                    try {
                                      Reference ref = FirebaseStorage.instance
                                          .ref()
                                          .child('photo-profile')
                                          .child('/' + user.uid + '.jpg');
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
                                      await ref.delete();

                                      await user.updateDisplayName(RegExp(
                                              r"^([^@]+)")
                                          .stringMatch(user.email.toString())
                                          .toString());
                                      await user.updatePhotoURL(
                                          "https://firebasestorage.googleapis.com/v0/b/myhealth-default-storage/o/blank_photo_profile.png?alt=media&token=b7c09a0d-cd6c-4514-9498-647b5df0bd28");

                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Hapus data berhasil.",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        backgroundColor: kYellow,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } on Exception catch (e) {
                                      print(e.toString());
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Hapus data gagal, muat ulang aplikasi.",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        backgroundColor: kYellow,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
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
                                  final googleSignIn = GoogleSignIn();
                                  final googleUser =
                                      await googleSignIn.signIn();
                                  if (googleUser!.email != user.email) {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Email yang dipilih tidak sesuai.",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: kYellow,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    final googleAuth =
                                        await googleUser.authentication;

                                    final credential =
                                        GoogleAuthProvider.credential(
                                      accessToken: googleAuth.accessToken,
                                      idToken: googleAuth.idToken,
                                    );

                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);

                                    try {
                                      Reference ref = FirebaseStorage.instance
                                          .ref()
                                          .child('photo-profile')
                                          .child('/' + user.uid + '.jpg');
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
                                      await ref.delete();
                                      try {
                                        await user.delete();
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Hapus data dan akun berhasil.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            WelcomeScreen()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      } catch (e) {
                                        print(e.toString());
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Hapus akun gagal, muat ulang aplikasi.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } on Exception catch (e) {
                                      print(e.toString());
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Hapus data dan akun gagal, muat ulang aplikasi.",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        backgroundColor: kYellow,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
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
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
