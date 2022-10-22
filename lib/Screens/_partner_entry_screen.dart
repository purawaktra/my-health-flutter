import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myhealth/constants.dart';

class TestPartnerEntryScreen extends StatefulWidget {
  final String partnerUid;
  const TestPartnerEntryScreen({Key? key, required this.partnerUid})
      : super(key: key);

  @override
  _TestPartnerEntryScreenState createState() => _TestPartnerEntryScreenState();
}

class _TestPartnerEntryScreenState extends State<TestPartnerEntryScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();
  late StreamSubscription userPhotoProfile;
  late StreamSubscription userFullnameStream;

  String displayPhotoUrl = "";
  String displayTextUserFullname = "Memuat...";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    userPhotoProfile = database
        .child('photoprofile')
        .child(this.widget.partnerUid)
        .onValue
        .listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayPhotoUrl = userData.toString();
      });
    });
    userFullnameStream = database
        .child('fullname')
        .child(this.widget.partnerUid)
        .onValue
        .listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayTextUserFullname = userData.toString();
      });
    });
  }

  @override
  void deactivate() {
    userPhotoProfile.cancel();
    userFullnameStream.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBlue1,
          title: Text("Partner Entry"),
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      displayTextUserFullname,
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
                          this.widget.partnerUid,
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: this.widget.partnerUid));
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
                  ]))),
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
              'Partner',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: kLightBlue1,
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
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
                        'Informasi Partner',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "Melihat biodata partner.",
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
            onTap: () {},
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
                    Icons.description_outlined,
                    color: kBlack,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rekam Medis Partner',
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
        ])));
  }
}
