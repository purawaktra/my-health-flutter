import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/qr_code_scanner_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ignore: camel_case_types
class qrCodeScreen extends StatefulWidget {
  const qrCodeScreen({Key? key}) : super(key: key);
  @override
  _qrCodeScreenState createState() => _qrCodeScreenState();
}

// ignore: camel_case_types
class _qrCodeScreenState extends State<qrCodeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Kode QR"),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 24,
          ),
          Align(
            alignment: Alignment.center,
            child: QrImage(
              data: user.uid,
              version: QrVersions.auto,
              size: size.width / 1.5,
              gapless: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Divider(
              color: Colors.black54,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 12),
            child: Row(
              children: [
                Icon(
                  Icons.qr_code,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Bagikan kode QR untuk:",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\u2022 Membagikan akses rekam medis anda.",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "\u2022 Menambahkan anda dalam akses rekam medis partner.",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 12),
            child: Row(
              children: [
                Icon(
                  Icons.qr_code,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Scan kode QR untuk:",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\u2022 Mendapatkan akses rekam medis partner.",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "\u2022 Menambahkan partner dalam akses rekam medis anda.",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 12),
            child: Row(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: kLightBlue1,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Dapatkan akses partner?",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SizedBox(
                width: 56,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => qrCodeScannerScreen()));
                },
                child: Text(
                  "QR Scanner",
                  style: TextStyle(color: kWhite),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kLightBlue1)),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
