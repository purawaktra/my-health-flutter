import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';

enum OptionMenu { setting, darkmode, notification, datausage }

class PartnerEntryScreen extends StatefulWidget {
  final AccessEntry partnerEntry;
  const PartnerEntryScreen({Key? key, required this.partnerEntry})
      : super(key: key);

  @override
  _PartnerEntryScreenState createState() => _PartnerEntryScreenState();
}

class _PartnerEntryScreenState extends State<PartnerEntryScreen> {
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();
  late OptionMenu _selection;
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
        .child(this.widget.partnerEntry.uid)
        .onValue
        .listen((event) {
      final Object? userData = event.snapshot.value;
      setState(() {
        displayPhotoUrl = userData.toString();
      });
    });
    userFullnameStream = database
        .child('fullname')
        .child(this.widget.partnerEntry.uid)
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
          actions: <Widget>[
            PopupMenuButton<OptionMenu>(
              onSelected: (OptionMenu result) {
                setState(() {
                  _selection = result;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<OptionMenu>>[
                const PopupMenuItem<OptionMenu>(
                  value: OptionMenu.notification,
                  child: Text('Notifikasi - BLOM'),
                ),
                const PopupMenuItem<OptionMenu>(
                  value: OptionMenu.datausage,
                  child: Text('Penggunaan Data - BLOM'),
                ),
                const PopupMenuItem<OptionMenu>(
                  value: OptionMenu.darkmode,
                  child: Text('Mode Malam - BLOM'),
                ),
                const PopupMenuItem<OptionMenu>(
                  value: OptionMenu.setting,
                  child: Text('Pengaturan - BLOM'),
                ),
              ],
            ),
          ],
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
                      backgroundImage: NetworkImage(displayPhotoUrl!),
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
                          this.widget.partnerEntry.uid,
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: this.widget.partnerEntry.uid));
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
                  ])))
        ])));
    ;
  }
}
