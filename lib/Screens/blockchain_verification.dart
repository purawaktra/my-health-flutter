import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:path_provider/path_provider.dart';

class BlockchainVerificationScreen extends StatefulWidget {
  const BlockchainVerificationScreen({Key? key}) : super(key: key);

  @override
  _BlockchainVerificationScreenState createState() =>
      _BlockchainVerificationScreenState();
}

class _BlockchainVerificationScreenState
    extends State<BlockchainVerificationScreen> {
  final storage = FirebaseStorage.instance.ref();
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  Directory? _externalDocumentsDirectory;

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
          title: Text("Verifikasi Blockchain"),
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
                    return Center(
                        child: Text(
                      "Error terjadi, refresh halaman :) \n Error code: ${snapshot.data}",
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
                    return Container(
                        child: ListView(children: [
                      for (int i = 0; i < healthRecordAccess.data.length; i++)
                        ExpansionTile(
                            title: Text(
                              healthRecordAccess.data[i].entryID,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "Block No $i",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  healthRecordAccess.data[i].date.toString(),
                                  style: TextStyle(
                                    color: Colors.black54,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                if (i >= 1)
                                  if (sha256
                                          .convert(utf8.encode(
                                              healthRecordAccess.data[i - 1]
                                                  .toJson()
                                                  .toString()))
                                          .toString() ==
                                      healthRecordAccess.data[i].hash)
                                    Icon(
                                      Icons.add_box,
                                      color: kLightBlue1,
                                    )
                                  else
                                    Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    )
                              ],
                            ),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: TextFormField(
                                  autofocus: false,
                                  readOnly: true,
                                  maxLines: null,
                                  controller: TextEditingController(
                                      text: healthRecordAccess.data[i].hash),
                                  style: TextStyle(color: kBlack),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.fingerprint),
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none,
                                    labelText: "Hash",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                  ),
                                ),
                              ),
                              if (i >= 1)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: TextFormField(
                                    autofocus: false,
                                    readOnly: true,
                                    maxLines: null,
                                    controller: TextEditingController(
                                        text: sha256
                                            .convert(utf8.encode(
                                                healthRecordAccess.data[i - 1]
                                                    .toJson()
                                                    .toString()))
                                            .toString()),
                                    style: TextStyle(color: kBlack),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.fingerprint),
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none,
                                      labelText: "Kalkulated Hash",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                  ),
                                ),
                            ])
                    ]));
                  }
                })));
  }
}
