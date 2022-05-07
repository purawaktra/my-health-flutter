import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final database = FirebaseDatabase.instance.ref();
    final storage = FirebaseStorage.instance.ref();
    Directory? _externalDocumentsDirectory;
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
                    ? FutureBuilder<DataSnapshot>(
                        future: database
                            .child("fullname")
                            .child(barcode!.code.toString())
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Center(
                              child: Row(
                                children: [
                                  Text(snapshot.data!.value.toString()),
                                  TapDebouncer(
                                    onTap: () async {
                                      bool result = false;

                                      try {
                                        final snackBar = SnackBar(
                                          content: const Text("Memuat...",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        File fileToHealthRecordAccess = File(
                                            "${_externalDocumentsDirectory!.path}/Akses Rekam Medis/blockchain.txt");

                                        await storage
                                            .child('health-record-access')
                                            .child(user.uid)
                                            .writeToFile(
                                                fileToHealthRecordAccess);

                                        String healthRecordAccessRaw =
                                            fileToHealthRecordAccess
                                                .readAsStringSync();
                                        print(healthRecordAccessRaw);
                                        AccessEntryBlockChain
                                            healthRecordAccess =
                                            AccessEntryBlockChain.fromJson(
                                                jsonDecode(
                                                    healthRecordAccessRaw));
                                        healthRecordAccess.data.add(AccessEntry(
                                            snapshot.data!.value.toString(),
                                            entryType: "request",
                                            enabled: true,
                                            uid:
                                                snapshot.data!.value.toString(),
                                            hash: sha256
                                                .convert(utf8.encode(
                                                    healthRecordAccess.data.last
                                                        .toJson()
                                                        .toString()))
                                                .toString(),
                                            date: "${DateTime.now().toLocal()}"
                                                .split(' ')[0]));
                                        healthRecordAccess.data.add(AccessEntry(
                                            snapshot.data!.value.toString(),
                                            entryType: "permit",
                                            enabled: true,
                                            uid:
                                                snapshot.data!.value.toString(),
                                            hash: sha256
                                                .convert(utf8.encode(
                                                    healthRecordAccess.data.last
                                                        .toJson()
                                                        .toString()))
                                                .toString(),
                                            date: "${DateTime.now().toLocal()}"
                                                .split(' ')[0]));
                                        Reference healthRecordAccessref =
                                            FirebaseStorage.instance
                                                .ref()
                                                .child('health-record-access')
                                                .child(user.uid);

                                        try {
                                          await healthRecordAccessref.putData(
                                              await fileToHealthRecordAccess
                                                  .readAsBytes());
                                          result = true;
                                        } catch (e) {
                                          print(e);
                                          try {
                                            await healthRecordAccessref.putFile(
                                                File(fileToHealthRecordAccess
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
                                          content: const Text("Berhasil.",
                                              style: TextStyle(
                                                  color: Colors.black)),
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
                                                  color: Colors.black)),
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
                                          style: TextStyle(color: kWhite),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(kLightBlue1)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
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
