import 'dart:async';
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
import 'package:path_provider/path_provider.dart';

class PermitHistoryScreen extends StatefulWidget {
  const PermitHistoryScreen({Key? key}) : super(key: key);

  @override
  _PermitHistoryScreenState createState() => _PermitHistoryScreenState();
}

class _PermitHistoryScreenState extends State<PermitHistoryScreen> {
  final storage = FirebaseStorage.instance.ref();
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  Directory? _externalDocumentsDirectory;

  Future<String> downloadAccessFile() async {
    String result = "false";
    try {
      _externalDocumentsDirectory = await getExternalStorageDirectory();
    } on Exception catch (e) {
      print(e);
      return result;
    } catch (e) {
      print(e);
    }
    Directory('${_externalDocumentsDirectory!.path}/Akses Rekam Medis/')
        .createSync(recursive: true);

    File downloadToFile = File(
        '${_externalDocumentsDirectory!.path}/Akses Rekam Medis/${user.uid}');
    try {
      await storage
          .child('health-record-access')
          .child(user.uid)
          .writeToFile(downloadToFile);

      result = downloadToFile.path;
      print(result);
    } catch (e) {
      // e.g, e.code == 'canceled'
      print('Download error: $e');
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Future<String> streamData = downloadAccessFile();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBlue1,
          title: Text("Permit List"),
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
                    String healthRecordData = snapshot.data!;
                    String healthRecordAccessRaw =
                        File(healthRecordData).readAsStringSync();
                    AccessEntryBlockChain healthRecordAccess =
                        AccessEntryBlockChain.fromJson(
                            jsonDecode(healthRecordAccessRaw));
                    Map<String, AccessEntry> accessPermit = {};
                    for (AccessEntry item in healthRecordAccess.data) {
                      if (item.entryType == "permit") if (item.enabled) {
                        accessPermit[item.uid] = item;
                      } else {
                        accessPermit.remove(item.uid);
                      }
                    }
                    return Container(
                      child: accessPermit.isNotEmpty
                          ? ListView(children: [
                              for (AccessEntry item in accessPermit.values)
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
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        item.enabled
                                            ? Icon(
                                                Icons.add_box,
                                                color: kLightBlue1,
                                              )
                                            : Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
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
                                                          entryType:
                                                              item.entryType,
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
                                                            "Berhasil.",
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
                                                            "Gagal, cek koneksi anda.",
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
                                                    "Hapus.",
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        child: TextFormField(
                                          autofocus: false,
                                          readOnly: true,
                                          maxLines: null,
                                          controller: TextEditingController(
                                              text: item.hash),
                                          style: TextStyle(color: kBlack),
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.fingerprint),
                                            hintStyle: TextStyle(
                                                color: Colors.black54),
                                            border: InputBorder.none,
                                            labelText: "Hash",
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        child: TextFormField(
                                          autofocus: false,
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: item.notes),
                                          style: TextStyle(color: kBlack),
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.note),
                                            hintStyle: TextStyle(
                                                color: Colors.black54),
                                            border: InputBorder.none,
                                            labelText: "Catatan",
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                          ),
                                        ),
                                      ),
                                    ])
                            ])
                          : Center(
                              child: Text(
                              "Kamu belum menambahkan siapapun disini :)",
                              style: TextStyle(
                                color: Colors.black54,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.center,
                            )),
                    );
                  }
                })));
  }
}
