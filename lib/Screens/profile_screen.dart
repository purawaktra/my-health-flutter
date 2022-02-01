import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/edit_profile_screen.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';

class ProfileScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    final userID = user.uid.toString();
    final userName = database.child('username');
    final userEmail = database.child('useremail');
    final urlImage = database.child('userurlphoto');
    var size = MediaQuery.of(context).size;

    return Background(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Profile",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Name: ' + user.displayName!,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Email: ' + user.email!,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                },
                child: Text(
                  "Upload list uid",
                  style: TextStyle(color: kWhite),
                ))
          ],
        ),
      ),
    );
  }
}
