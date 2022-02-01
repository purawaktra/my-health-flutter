import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/background_raw.dart';

import '../constants.dart';

class EditProfileScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    final userID = user.uid.toString();
    final userName = database.child('username');
    final userEmail = database.child('useremail');
    final urlImage = database.child('userurlphoto');

    return BackgroundRaw(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  userEmail.set({userID: userEmail});
                },
                child: Text(
                  "Upload userid to firebase",
                  style: TextStyle(color: kWhite),
                )),
          ],
        ),
      ),
    );
  }
}
