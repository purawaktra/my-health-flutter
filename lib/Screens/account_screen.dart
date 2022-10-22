import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myhealth/screens/profile_screen.dart';
import 'package:myhealth/components/sign_method.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/add_email_provider_screen.dart';
import 'package:myhealth/screens/blockchain_verification.dart';
import 'package:myhealth/screens/change_password_screen.dart';
import 'package:myhealth/screens/delete_account_screen.dart';
import 'package:myhealth/screens/developer_info_screen.dart';
import 'package:myhealth/screens/onboarding_screen.dart';
import 'package:myhealth/screens/qr_code_screen.dart';
import 'package:provider/provider.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

enum OptionMenu { setting, darkmode, notification, datausage }

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  late StreamSubscription userPhotoProfile;
  late StreamSubscription userDisplayName;
  final database = FirebaseDatabase.instance.ref();
  String displayPhotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/myhealth-default-storage/o/blank_photo_profile.png?alt=media&token=b7c09a0d-cd6c-4514-9498-647b5df0bd28";
  String displayName = "Memuat...";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    userPhotoProfile =
        database.child('photoprofile').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayPhotoUrl = userData.toString();
      });
    });

    userPhotoProfile =
        database.child('displayname').child(user.uid).onValue.listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayName = userData.toString();
      });
    });
  }

  @override
  void deactivate() {
    userPhotoProfile.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    uploadPhotoProfile(XFile? file) async {
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file was selected'),
          ),
        );

        return null;
      }
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('photo-profile')
          .child('/' + user.uid);

      try {
        await ref.putData(await file.readAsBytes(), metadata);
      } catch (e) {
        print(e);
        try {
          await ref.putFile(File(file.path), metadata);
        } catch (e) {
          print(e);
        }
      }

      final link = await ref.getDownloadURL();
      return link;
    }

    late OptionMenu _selection;
    final TextEditingController displayNameController =
        new TextEditingController(text: displayName);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Akun"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(displayPhotoUrl),
                      key: ValueKey(displayPhotoUrl),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      displayName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user.uid,
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: user.uid));
                              final snackBar = SnackBar(
                                content: const Text("Tersalin ke clipboard.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: Icon(
                              Icons.copy_outlined,
                              color: Colors.black45,
                              size: 16,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 10, bottom: 5),
              child: Text(
                'Akun',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kLightBlue1,
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => qrCodeScreen()));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.qr_code,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kode QR',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.data_array_outlined,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Pribadi',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "Melihat atau mengubah biodata pribadi.",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext alertContext) {
                      return AlertDialog(
                        content: Stack(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      autofocus: false,
                                      controller: displayNameController,
                                      style: TextStyle(color: kBlack),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("");
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.credit_card,
                                          color: kBlack,
                                        ),
                                        labelText: "Nama Tampilan",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        border: InputBorder.none,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        errorStyle: TextStyle(height: 0),
                                      ),
                                    ),
                                  ),
                                  TapDebouncer(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        await database.update({
                                          "displayname/" + user.uid:
                                              displayNameController.text,
                                        });

                                        await user
                                            .updateDisplayName(
                                                displayNameController.text)
                                            .whenComplete(() => setState(() {
                                                  displayName =
                                                      displayNameController
                                                          .text;
                                                }));
                                        Navigator.of(alertContext).pop();
                                        final snackBar = SnackBar(
                                          content: const Text("Memuat...",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Form isian masih kosong",
                                              style: TextStyle(
                                                  color: Colors.black)),
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
                                          "Simpan",
                                          style: TextStyle(color: kWhite),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(kLightBlue1)),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.short_text_outlined,
                      color: kBlack,
                    ),
                  ),
                  Text(
                    "Ganti nama tampilan",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            TapDebouncer(
              onTap: () async {
                final XFile? file =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (file == null) {
                  final snackBar = SnackBar(
                    content: const Text("Dibatalkan.",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: kYellow,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  String? photoURL = await uploadPhotoProfile(file);
                  await database.update({"photoprofile/" + user.uid: photoURL});
                  await user.updatePhotoURL(photoURL);
                  setState(() {
                    displayPhotoUrl = photoURL!;
                  });
                  final snackBar = SnackBar(
                    content: const Text("Memuat...",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: kYellow,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              builder: (BuildContext context, TapDebouncerFunc? onTap) {
                return InkWell(
                  onTap: onTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Icon(
                          Icons.photo_outlined,
                          color: kBlack,
                        ),
                      ),
                      Text(
                        'Ganti foto profil',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 10, bottom: 5),
              child: Text(
                'Sosial Media',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kLightBlue1,
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                final googleUser = await GoogleSignIn().signIn();
                if (googleUser == null) {
                  final snackBar = SnackBar(
                    content: Text("Dibatalkan.",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: kYellow,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  final googleAuth = await googleUser.authentication;

                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  try {
                    await user.linkWithCredential(credential);
                    final snackBar = SnackBar(
                      content: Text("Google berhasil ditautkan.",
                          style: TextStyle(color: Colors.black)),
                      backgroundColor: kYellow,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "provider-already-linked" ||
                        e.code == "credential-already-in-use") {
                      final snackBar = SnackBar(
                        content: Text("Akun sudah tertaut.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      final snackBar = SnackBar(
                        content: Text("Gagal, error code: ${e.code}.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.g_mobiledata,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Builder(builder: ((googleProviderContext) {
                          List<UserInfo> listProvider = user.providerData;
                          for (UserInfo provider in listProvider) {
                            if (provider.providerId == "google.com") {
                              return Text(
                                "Akun sudah tertaut dengan akun google.",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              );
                            }
                          }
                          return Text(
                            "Tambahkan Google dalam koneksi akun.",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          );
                        }))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                bool state = true;
                List<UserInfo> listProvider = user.providerData;
                for (UserInfo provider in listProvider) {
                  if (provider.providerId == "password") {
                    state = false;
                  }
                }
                if (state) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddEmailProviderScreen()));
                  await user.reload();
                } else {
                  final snackBar = SnackBar(
                    content: Text("Akun sudah tertaut.",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: kYellow,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.email_outlined,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Builder(builder: ((googleProviderContext) {
                          List<UserInfo> listProvider = user.providerData;
                          for (UserInfo provider in listProvider) {
                            if (provider.providerId == "google.com") {
                              return Text(
                                "Akun sudah tertaut dengan akun email.",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              );
                            }
                          }
                          return Container();
                        }))
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 10, bottom: 5),
              child: Text(
                'Keamanan',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kLightBlue1,
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlockchainVerificationScreen()));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.fingerprint,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verifikasi Blockchain',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "Kalkulasi hash untuk verifikasi list partner.",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                bool state = false;
                List<UserInfo> listProvider = user.providerData;
                for (UserInfo provider in listProvider) {
                  print(provider.providerId);
                  if (provider.providerId == "password") {
                    state = true;
                  }
                }
                if (state) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()));
                } else {
                  final snackBar = SnackBar(
                    content: Text("Akun tidak tertaut dengan password.",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: kYellow,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.password,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ubah kata sandi',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DeleteAccountScreen()));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.delete_outline,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hapus Data',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "Menghapus data, dan akun.",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final provider =
                    Provider.of<SignProvider>(context, listen: false);
                String logoutstate = await provider.logout();

                if (logoutstate == "true") {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => OnboardingScreen()),
                      (Route<dynamic> route) => false);
                } else if (logoutstate == "false") {
                  final snackBar = SnackBar(
                    content: const Text(
                        "Gagal untuk logout, silahkan coba kembali.",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: Color(0xFFF8B501),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.logout_outlined,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Logout Akun',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 10, bottom: 5),
              child: Text(
                'Bantuan',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kLightBlue1,
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                final Uri params = Uri(
                    scheme: 'mailto',
                    path: 'akbar.muhammadakbarmaulana@gmail.com',
                    query: 'subject=myHealth Manajemen Rekam Medis');
                try {
                  await launchUrl(params);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Eror terjadi, error code: $e'),
                    ),
                  );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.contact_mail_outlined,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kontak Kami',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "Pertanyaan? Bantuan?",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       SizedBox(
            //         width: 10,
            //       ),
            //       SizedBox(
            //         height: 60,
            //         width: 60,
            //         child: Icon(
            //           Icons.share,
            //           color: kBlack,
            //         ),
            //       ),
            //       Expanded(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               'Bagikan Aplikasi',
            //               style: TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 18,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DeveloperInfoScreen()));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.info_outline,
                      color: kBlack,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Info Pengembang',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
