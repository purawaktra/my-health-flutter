import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/add_entry_access.dart';
import 'package:path_provider/path_provider.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class EntryHealthRecord {
  final String accesstype;
  final String userid;
  final String enabled;
  final String date;
  final String hash;

  EntryHealthRecord(
      this.accesstype, this.userid, this.enabled, this.date, this.hash);
}

class HealthRecordAccessScreen extends StatefulWidget {
  const HealthRecordAccessScreen({Key? key}) : super(key: key);
  @override
  _HealthRecordAccessScreenState createState() =>
      _HealthRecordAccessScreenState();
}

class _HealthRecordAccessScreenState extends State<HealthRecordAccessScreen> {
  Directory? _externalDocumentsDirectory;
  late WhyFarther _selection;
  late Future<String> streamData;
  final storage = FirebaseStorage.instance.ref();
  final user = FirebaseAuth.instance.currentUser!;

  Future<String> downloadFile() async {
    String result = "false";
    try {
      _externalDocumentsDirectory = await getExternalStorageDirectory();
      print(_externalDocumentsDirectory!.path);
    } on Exception catch (e) {
      print(e);
      return result;
    }
    File downloadToFile =
        File('${_externalDocumentsDirectory!.path}/${user.uid}');
    try {
      await storage
          .child('health-record-access')
          .child(user.uid)
          .writeToFile(downloadToFile);

      result = '${_externalDocumentsDirectory!.path}/${user.uid}';
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print('Download error: $e');
      return (e.code);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Future<String> streamData = downloadFile();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBlue1,
          title: Text("Partner"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              tooltip: 'Refresh Halaman',
              onPressed: () {
                setState(() {
                  streamData = downloadFile();
                });
              },
            ),
            PopupMenuButton<WhyFarther>(
              onSelected: (WhyFarther result) {
                setState(() {
                  _selection = result;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.harder,
                  child: Text('Working a lot harder'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.smarter,
                  child: Text('Being a lot smarter'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.selfStarter,
                  child: Text('Being a self-starter'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.tradingCharter,
                  child: Text('Placed in charge of trading charter'),
                ),
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
            displacement: 18,
            onRefresh: () {
              setState(() {
                streamData = downloadFile();
              });
              return downloadFile();
            },
            child: FutureBuilder<String>(
                future: streamData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Text(
                      "Memuat...",
                      style: TextStyle(
                        color: Colors.black54,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ));
                  } else if (!snapshot.hasError) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "Sepertinya datanya ga ada, coba buat entry dulu deh :) \n Error code: ${snapshot.error.toString()}",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
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
                  } else {
                    String healthRecordData = snapshot.data!;
                    if (healthRecordData == "object-not-found") {
                      return Center(
                          child: Text(
                        "Sepertinya datanya ga ada, coba buat entry dulu deh :)",
                        style: TextStyle(
                          color: Colors.black54,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ));
                    } else {
                      return Center(
                          child: Text(
                        "Gagal mendownload datanyaa, pastikan kamu punya kuota internet :)",
                        style: TextStyle(
                          color: Colors.black54,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ));
                    }
                  }
                })));
  }
}
