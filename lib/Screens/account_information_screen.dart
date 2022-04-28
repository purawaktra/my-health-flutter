import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';

class AccountInformationScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    final TextEditingController userCreationDateController =
        new TextEditingController(
            text: user.metadata.creationTime.toString().split(' ')[0]);
    final creationDateField = TextFormField(
      autofocus: false,
      readOnly: true,
      controller: userCreationDateController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.date_range_outlined,
          color: kBlack,
        ),
        hintText: "Akun dibuat",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Akun dibuat",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );

    final TextEditingController userLastLoginController =
        new TextEditingController(
            text: user.metadata.lastSignInTime.toString().split(' ')[0]);
    final lastLoginField = TextFormField(
      autofocus: false,
      readOnly: true,
      controller: userLastLoginController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.login_outlined,
          color: kBlack,
        ),
        hintText: "Terakhir Masuk",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Terakhir Masuk",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
    return Background(
        title: "Informasi Akun",
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
                    ],
                  ),
                ),
                Divider(
                  color: kDarkBlue,
                ),
                creationDateField,
                lastLoginField
              ]),
        )));
  }
}
