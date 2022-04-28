import 'package:flutter/material.dart';
import 'package:myhealth/components/background.dart';

class SharedHealthRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
        title: "Dibagikan dengan saya",
        description: Text("Deskripsi kosong."),
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(24.0), child: Container())));
  }
}
