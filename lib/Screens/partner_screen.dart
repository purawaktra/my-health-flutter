import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/add_partner_screen.dart';
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

class EntryAccessScreen extends StatefulWidget {
  const EntryAccessScreen({Key? key}) : super(key: key);
  @override
  _EntryAccessScreenState createState() => _EntryAccessScreenState();
}

class _EntryAccessScreenState extends State<EntryAccessScreen> {
  Directory? _externalDocumentsDirectory;
  late WhyFarther _selection;
  late Future<String> streamData;
  final user = FirebaseAuth.instance.currentUser!;
  final storage = FirebaseStorage.instance.ref();

  Future<String> putAccessFile() async {
    try {
      var accessEntry = AccessEntryBlockChain(user.uid);
      Directory('${_externalDocumentsDirectory!.path}/Akses Rekam Medis/')
          .createSync(recursive: true);

      File fileToHealthRecordAccess = File(
          "${_externalDocumentsDirectory!.path}/Akses Rekam Medis/blockchain.txt");

      fileToHealthRecordAccess.writeAsString(jsonEncode(accessEntry.toJson()));

      Reference healthRecordAccessref = FirebaseStorage.instance
          .ref()
          .child('health-record-access')
          .child(user.uid);

      try {
        await healthRecordAccessref
            .putData(await fileToHealthRecordAccess.readAsBytes());
      } catch (e) {
        print(e);
        try {
          await healthRecordAccessref
              .putFile(File(fileToHealthRecordAccess.path));
        } catch (e) {
          print(e);
          return "false";
        }
      }
      return "true";
    } catch (e) {
      print(e.toString());
      return "false";
    }
  }

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
          .child(user.uid)
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
  Widget build(BuildContext context) {
    Future<String> streamData = downloadAccessFile();
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
                  streamData = downloadAccessFile();
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: kLightBlue1,
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => AddEntryHealthRecordAccessScreen()))
              .whenComplete(() => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget))),
          tooltip: 'Rekam Medis Baru',
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: RefreshIndicator(
            displacement: 18,
            onRefresh: () {
              setState(() {
                streamData = downloadAccessFile();
              });
              return downloadAccessFile();
            },
            child: FutureBuilder<String>(
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
                  } else {
                    String healthRecordData = snapshot.data!;

                    if (healthRecordData == "object-not-found") {
                      putAccessFile();
                      return Center(
                          child: Text(
                        "Sepertinya datanya ga ada, coba buat entry dulu deh :) \n Error code: ${snapshot.error.toString()}",
                        style: TextStyle(
                          color: Colors.black54,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                      ));
                    } else {
                      String healthRecordAccessRaw =
                          File(healthRecordData).readAsStringSync();
                      print(healthRecordAccessRaw);
                      AccessEntryBlockChain healthRecordAccess =
                          AccessEntryBlockChain.fromJson(
                              jsonDecode(healthRecordAccessRaw));
                      List<String> accessRequest = [];
                      List<String> accessPermit = [];
                      for (AccessEntry healthRecordAccessEntry
                          in healthRecordAccess.data) {
                        if (healthRecordAccessEntry.entryType == "request") {
                          if (healthRecordAccessEntry.enabled) {
                            accessRequest.add(healthRecordAccessEntry.entryID);
                          } else {
                            accessRequest
                                .remove(healthRecordAccessEntry.entryID);
                          }
                        } else if (healthRecordAccessEntry.entryType ==
                            "permit") {
                          if (healthRecordAccessEntry.enabled) {
                            accessPermit.add(healthRecordAccessEntry.entryID);
                          } else {
                            accessPermit
                                .remove(healthRecordAccessEntry.entryID);
                          }
                        }
                      }
                      return Container(
                          //     child: Column(
                          //   children: <Widget>[
                          //     Container(
                          //       child: ListView(
                          //         children: [],
                          //       ),
                          //     )
                          //   ],
                          // )
                          );
                    }
                  }
                })));
  }
}
