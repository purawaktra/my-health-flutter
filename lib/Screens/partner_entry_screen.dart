import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/partner_to_user_permission_history.dart';
import 'package:myhealth/screens/partner_health_record_screen.dart';
import 'package:myhealth/screens/partner_profile_screen.dart';
import 'package:myhealth/screens/user_to_partner_permission_history.dart';
import 'package:path_provider/path_provider.dart';

class PartnerEntryScreen extends StatefulWidget {
  final AccessEntry partnerEntry;
  const PartnerEntryScreen({Key? key, required this.partnerEntry})
      : super(key: key);

  @override
  _PartnerEntryScreenState createState() => _PartnerEntryScreenState();
}

class _PartnerEntryScreenState extends State<PartnerEntryScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();
  late StreamSubscription userPhotoProfile;
  late StreamSubscription userFullnameStream;
  Directory? _externalDocumentsDirectory;

  String displayPhotoUrl = "";
  String displayTextUserFullname = "Memuat...";

  Future<String> downloadAccessFile() async {
    String result = "false";
    try {
      _externalDocumentsDirectory = await getExternalStorageDirectory();
      print(_externalDocumentsDirectory!.path);
    } on Exception catch (e) {
      print(e);
      return result;
    }
    File downloadToFile = File(
        '${_externalDocumentsDirectory!.path}/Akses Rekam Medis/blockchain.txt');
    try {
      await storage
          .child('health-record-access')
          .child(this.widget.partnerEntry.uid)
          .writeToFile(downloadToFile);

      result = downloadToFile.path;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print('Download error: $e');
      return e.code;
    }
    return result;
  }

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
    Future<String> streamData = downloadAccessFile();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBlue1,
          title: Text("Partner Entry"),
        ),
        body: FutureBuilder<String>(
            future: streamData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Text(
                  "Menunggu Server...",
                  style: TextStyle(
                    color: Colors.black54,
                    overflow: TextOverflow.ellipsis,
                  ),
                ));
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text(
                  "Memuat...",
                  style: TextStyle(
                    color: Colors.black54,
                    overflow: TextOverflow.ellipsis,
                  ),
                ));
              } else if (snapshot.data == "object-not-found" ||
                  snapshot.data == "unknown") {
                return Center(
                    child: Text(
                  "Partner belum menginisialisasi akun. \n Error code: ${snapshot.error.toString()}",
                  style: TextStyle(
                    color: Colors.black54,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.center,
                ));
              } else {
                String healthRecordData = snapshot.data!;
                String healthRecordAccessRaw =
                    File(healthRecordData).readAsStringSync();
                print(healthRecordAccessRaw);
                AccessEntryBlockChain healthRecordAccess =
                    AccessEntryBlockChain.fromJson(
                        jsonDecode(healthRecordAccessRaw));
                List<AccessEntry> accessHistory = [];
                for (AccessEntry healthRecordAccessEntry
                    in healthRecordAccess.data)
                  if (healthRecordAccessEntry.uid == user.uid) {
                    accessHistory.add(healthRecordAccessEntry);
                  }

                return Builder(builder: ((context) {
                  bool permitStatus = false;
                  for (AccessEntry item in accessHistory)
                    if (item.entryType == "permit") {
                      permitStatus = item.enabled;
                      print(permitStatus);
                    }
                  if (permitStatus) {
                    return SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 12, right: 12),
                              child: Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                    CircleAvatar(
                                      radius: 80,
                                      backgroundImage:
                                          NetworkImage(displayPhotoUrl),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          this.widget.partnerEntry.uid,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 14),
                                        ),
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            visualDensity: VisualDensity(
                                                horizontal: -4, vertical: -4),
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: this
                                                      .widget
                                                      .partnerEntry
                                                      .uid));
                                              final snackBar = SnackBar(
                                                content: const Text(
                                                    "Tersalin ke clipboard.",
                                                    style: TextStyle(
                                                        color: Colors.black)),
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
                            padding: const EdgeInsets.only(
                                left: 24, top: 10, bottom: 5),
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
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PartnerProfileScreen(
                                        partnerEntry: this.widget.partnerEntry,
                                      )));
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      PartnerHealthRecordScreen(
                                        partnerEntry: this.widget.partnerEntry,
                                      )));
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
                                    Icons.description_outlined,
                                    color: kBlack,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      PartnerToUserPermissionHistoryScreen(
                                        partnerEntry: this.widget.partnerEntry,
                                      )));
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
                                    Icons.history_toggle_off,
                                    color: kBlack,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Riwayat Partner',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "Izin yang diberikan kepada anda.",
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      UserToPartnerPermissionHistoryScreen(
                                        partnerEntry: this.widget.partnerEntry,
                                      )));
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
                                    Icons.history_toggle_off,
                                    color: kBlack,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Riwayat Anda',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "Izin yang anda berikan.",
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
                        ]));
                  } else {
                    return Center(
                        child: Text(
                      "Partner belum menambahkan anda dalam list partner. \n Error code: ${snapshot.error.toString()}",
                      style: TextStyle(
                        color: Colors.black54,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.center,
                    ));
                    ;
                  }
                }));
              }
            }));
  }
}
