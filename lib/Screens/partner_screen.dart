import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/generate.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/add_partner_screen.dart';
import 'package:myhealth/screens/partner_entry_screen.dart';
import 'package:myhealth/screens/permit_screen.dart';
import 'package:myhealth/screens/user_permission_history.dart';
import 'package:path_provider/path_provider.dart';

enum OptionMenu { history, permit }

class EntryHealthRecord {
  final String accesstype;
  final String userid;
  final String enabled;
  final String date;
  final String hash;

  EntryHealthRecord(
      this.accesstype, this.userid, this.enabled, this.date, this.hash);
}

class PartnerAccessScreen extends StatefulWidget {
  const PartnerAccessScreen({Key? key}) : super(key: key);
  @override
  _PartnerAccessScreenState createState() => _PartnerAccessScreenState();
}

class _PartnerAccessScreenState extends State<PartnerAccessScreen> {
  Directory? _externalDocumentsDirectory;
  late OptionMenu _selection;
  late Future<String> streamData;
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();

  Future<String> putAccessFile() async {
    try {
      var accessEntry = AccessEntryBlockChain(user.uid);
      _externalDocumentsDirectory = await getExternalStorageDirectory();
      Directory('${_externalDocumentsDirectory!.path}/Akses Rekam Medis/')
          .createSync(recursive: true);

      File fileToHealthRecordAccess = File(
          "${_externalDocumentsDirectory!.path}/Akses Rekam Medis/${user.uid}");

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
        '${_externalDocumentsDirectory!.path}/Akses Rekam Medis/${user.uid}');
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
            PopupMenuButton<OptionMenu>(
              onSelected: (OptionMenu result) {
                if (result.name == "history") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserPermissionHistoryScreen()));
                }
                if (result.name == "permit") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PermitHistoryScreen()));
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<OptionMenu>>[
                const PopupMenuItem<OptionMenu>(
                  value: OptionMenu.permit,
                  child: Text('Izin yang diberikan'),
                ),
                const PopupMenuItem<OptionMenu>(
                  value: OptionMenu.history,
                  child: Text('Riwayat'),
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
              .whenComplete(() => setState(() {
                    streamData = downloadAccessFile();
                  })),
          tooltip: 'Partner baru',
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
                  } else if (snapshot.data == "object-not-found" ||
                      snapshot.data == "unknown") {
                    putAccessFile();
                    return Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/partner_screen.png",
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Kamu belum menambahkan partner, kamu bisa berbagi rekam medis kamu dengan menambahkan partner lewat tombol tambah dibawah ya.",
                            style: const TextStyle(
                                color: kBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ));
                  } else {
                    String healthRecordData = snapshot.data!;
                    String healthRecordAccessRaw =
                        File(healthRecordData).readAsStringSync();
                    AccessEntryBlockChain healthRecordAccess =
                        AccessEntryBlockChain.fromJson(
                            jsonDecode(healthRecordAccessRaw));
                    Map<String, AccessEntry> accessRequest = {};
                    Map<String, AccessEntry> accessPermit = {};
                    for (AccessEntry healthRecordAccessEntry
                        in healthRecordAccess.data) {
                      if (healthRecordAccessEntry.entryType == "request") {
                        if (healthRecordAccessEntry.enabled) {
                          accessRequest[healthRecordAccessEntry.uid] =
                              healthRecordAccessEntry;
                        } else {
                          accessRequest.remove(healthRecordAccessEntry.uid);
                        }
                      } else if (healthRecordAccessEntry.entryType ==
                          "permit") {
                        if (healthRecordAccessEntry.enabled) {
                          accessPermit[healthRecordAccessEntry.uid] =
                              healthRecordAccessEntry;
                        } else {
                          accessPermit.remove(healthRecordAccessEntry.uid);
                        }
                      }
                    }
                    return Container(
                      child: accessRequest.isNotEmpty
                          ? ListView(
                              children: [
                                for (AccessEntry item in accessRequest.values)
                                  ExpansionTile(
                                    title: FutureBuilder<DataSnapshot>(
                                        future: database
                                            .child("fullname")
                                            .child(item.uid)
                                            .get(),
                                        builder: (context2, snapshot) {
                                          Widget child = Text("Memuat...",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              ));
                                          if (snapshot.hasData) if (snapshot
                                              .data!.value
                                              .toString()
                                              .isNotEmpty) {
                                            child = Text(
                                              snapshot.data!.value.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          } else {
                                            child = Text(
                                              "Nama partner belum diatur.",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }

                                          return child;
                                        }),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          item.entryID,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          item.date.toString(),
                                          style: TextStyle(
                                            color: Colors.black54,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 60,
                                              width: 60,
                                              child: Card(
                                                color: kLightBlue2,
                                                elevation: 4,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PartnerEntryScreen(
                                                                  partnerEntry:
                                                                      item,
                                                                )));
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.open_in_new,
                                                        color: kBlack,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 60,
                                              width: 60,
                                              child: Card(
                                                color: kRed,
                                                elevation: 4,
                                                child: InkWell(
                                                  onTap: () {
                                                    final snackBar = SnackBar(
                                                      content: const Text(
                                                          "Double klik untuk menghapus.",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      backgroundColor: kYellow,
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  },
                                                  onDoubleTap: () async {
                                                    bool result = false;
                                                    try {
                                                      healthRecordAccess.data.add(AccessEntry(
                                                          generateRandomString(
                                                              10),
                                                          entryType: "permit",
                                                          enabled: false,
                                                          uid: item.uid,
                                                          hash: sha256
                                                              .convert(utf8.encode(
                                                                  healthRecordAccess
                                                                      .data.last
                                                                      .toJson()
                                                                      .toString()))
                                                              .toString(),
                                                          date:
                                                              "${DateTime.now().toLocal()}"
                                                                  .split(
                                                                      ' ')[0]));
                                                      healthRecordAccess.data.add(AccessEntry(
                                                          generateRandomString(
                                                              10),
                                                          entryType: "request",
                                                          enabled: false,
                                                          uid: item.uid,
                                                          hash: sha256
                                                              .convert(utf8.encode(
                                                                  healthRecordAccess
                                                                      .data.last
                                                                      .toJson()
                                                                      .toString()))
                                                              .toString(),
                                                          date:
                                                              "${DateTime.now().toLocal()}"
                                                                  .split(
                                                                      ' ')[0]));
                                                      File(healthRecordData)
                                                          .writeAsString(jsonEncode(
                                                              healthRecordAccess
                                                                  .toJson()));
                                                      Reference
                                                          healthRecordAccessref =
                                                          FirebaseStorage
                                                              .instance
                                                              .ref()
                                                              .child(
                                                                  'health-record-access')
                                                              .child(user.uid);

                                                      try {
                                                        await healthRecordAccessref
                                                            .putData(await File(
                                                                    healthRecordData)
                                                                .readAsBytes());
                                                        result = true;
                                                      } catch (e) {
                                                        print(e);
                                                        try {
                                                          await healthRecordAccessref
                                                              .putFile(File(
                                                                  healthRecordData));
                                                          result = true;
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      }
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                    if (result) {
                                                      final snackBar = SnackBar(
                                                        content: const Text(
                                                            "Terhapus.",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        backgroundColor:
                                                            kYellow,
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      setState(() {
                                                        streamData =
                                                            downloadAccessFile();
                                                      });
                                                    } else {
                                                      final snackBar = SnackBar(
                                                        content: const Text(
                                                            "Gagal menghapus, silahkan ulangi kembali.",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        backgroundColor:
                                                            kYellow,
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.delete,
                                                        color: kWhite,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Buka dan hapus.",
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
                                    ],
                                  ),
                              ],
                            )
                          : Container(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/partner_screen.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    "Kamu belum menambahkan partner, kamu bisa berbagi rekam medis kamu dengan menambahkan partner lewat tombol tambah dibawah ya.",
                                    style: const TextStyle(
                                        color: kBlack,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )),
                    );
                  }
                })));
  }
}
