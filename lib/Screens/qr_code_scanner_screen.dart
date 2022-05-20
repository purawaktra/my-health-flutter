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
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

// ignore: camel_case_types
class qrCodeScannerScreen extends StatefulWidget {
  const qrCodeScannerScreen({Key? key}) : super(key: key);
  @override
  _qrCodeScannerScreenState createState() => _qrCodeScannerScreenState();
}

// ignore: camel_case_types
class _qrCodeScannerScreenState extends State<qrCodeScannerScreen> {
  final qrKey = GlobalKey(debugLabel: "QR");
  Directory? _externalDocumentsDirectory;
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();

  late QRViewController controller;
  Barcode? barcode;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Future<void> reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller.pauseCamera();
    }
    controller.resumeCamera();
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

  @override
  Widget build(BuildContext context) {
    Future<String> streamData = downloadAccessFile();

    return SafeArea(
        child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.white,
              child: Center(
                child: barcode != null
                    ? Builder(builder: (context) {
                        controller.pauseCamera();
                        return FutureBuilder<DataSnapshot>(
                            future: database
                                .child("fullname")
                                .child(barcode!.code.toString())
                                .get(),
                            builder: (context, snapshot1) {
                              if (snapshot1.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (!snapshot1.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return FutureBuilder<String>(
                                    future: streamData,
                                    builder: (context, snapshot2) {
                                      if (snapshot2.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: Text(
                                          "Menunggu Server...",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ));
                                      } else if (!snapshot2.hasData) {
                                        return Center(
                                            child: Text(
                                          "Memuat...",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ));
                                      } else if (snapshot2.data ==
                                              "object-not-found" ||
                                          snapshot2.data == "unknown") {
                                        putAccessFile();
                                        return Center(
                                            child: Text(
                                          "Error terjadi, refresh halaman :) \n Error code: ${snapshot2.data}",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          textAlign: TextAlign.center,
                                        ));
                                      } else {
                                        String healthRecordData =
                                            snapshot2.data!;
                                        String healthRecordAccessRaw =
                                            File(healthRecordData)
                                                .readAsStringSync();
                                        AccessEntryBlockChain
                                            healthRecordAccess =
                                            AccessEntryBlockChain.fromJson(
                                                jsonDecode(
                                                    healthRecordAccessRaw));
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(snapshot1.data!.value
                                                .toString()),
                                            TapDebouncer(
                                              onTap: () async {
                                                bool result = false;

                                                try {
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        "Memuat...",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    backgroundColor: kYellow,
                                                  );
                                                  _externalDocumentsDirectory =
                                                      await getExternalStorageDirectory();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  File
                                                      fileToHealthRecordAccess =
                                                      File(
                                                          "${_externalDocumentsDirectory!.path}/Akses Rekam Medis/${user.uid}");
                                                  healthRecordAccess.data.add(AccessEntry(
                                                      generateRandomString(10),
                                                      entryType: "request",
                                                      enabled: true,
                                                      uid: barcode!.code
                                                          .toString(),
                                                      hash: sha256
                                                          .convert(utf8.encode(
                                                              healthRecordAccess
                                                                  .data.last
                                                                  .toJson()
                                                                  .toString()))
                                                          .toString(),
                                                      date:
                                                          "${DateTime.now().toLocal()}"
                                                              .split(' ')[0]));
                                                  healthRecordAccess.data.add(AccessEntry(
                                                      generateRandomString(10),
                                                      entryType: "permit",
                                                      enabled: true,
                                                      uid: barcode!.code
                                                          .toString(),
                                                      hash: sha256
                                                          .convert(utf8.encode(
                                                              healthRecordAccess
                                                                  .data.last
                                                                  .toJson()
                                                                  .toString()))
                                                          .toString(),
                                                      date:
                                                          "${DateTime.now().toLocal()}"
                                                              .split(' ')[0]));
                                                  fileToHealthRecordAccess
                                                      .writeAsString(jsonEncode(
                                                          healthRecordAccess
                                                              .toJson()));
                                                  Reference
                                                      healthRecordAccessref =
                                                      FirebaseStorage.instance
                                                          .ref()
                                                          .child(
                                                              'health-record-access')
                                                          .child(user.uid);

                                                  try {
                                                    await healthRecordAccessref
                                                        .putData(
                                                            await fileToHealthRecordAccess
                                                                .readAsBytes());

                                                    result = true;
                                                  } catch (e) {
                                                    print(e);
                                                    try {
                                                      await healthRecordAccessref
                                                          .putFile(File(
                                                              fileToHealthRecordAccess
                                                                  .path));
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
                                                            color:
                                                                Colors.black)),
                                                    backgroundColor: kYellow,
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  Navigator.of(context).pop();
                                                } else {
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        "Gagal, cek koneksi anda.",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    backgroundColor: kYellow,
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              },
                                              builder: (BuildContext context,
                                                  TapDebouncerFunc? onTap) {
                                                return ElevatedButton(
                                                  onPressed: onTap,
                                                  child: Text(
                                                    "Tambahkan Partner",
                                                    style: TextStyle(
                                                        color: kWhite),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  kLightBlue1)),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    });
                              }
                            });
                      })
                    : Text("Arahkan ke QR Code"),
              ),
            ),
          )
        ],
      ),
    ));
  }

  buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
          borderColor: kLightBlue1,
          borderWidth: 8),
    );
  }

  void onQRViewCreated(QRViewController p1) {
    setState(() {
      this.controller = p1;
    });
    controller.scannedDataStream.listen((event) {
      setState(() {
        this.barcode = event;
      });
    });
  }
}
