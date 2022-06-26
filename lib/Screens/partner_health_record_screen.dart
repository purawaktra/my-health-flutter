import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/partner_health_record_entry_screen.dart';
import 'package:path_provider/path_provider.dart';

class PartnerHealthRecordScreen extends StatefulWidget {
  final AccessEntry partnerEntry;
  const PartnerHealthRecordScreen({Key? key, required this.partnerEntry})
      : super(key: key);
  @override
  _PartnerHealthRecordScreenState createState() =>
      _PartnerHealthRecordScreenState();
}

class _PartnerHealthRecordScreenState extends State<PartnerHealthRecordScreen> {
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();
  Directory? _externalDocumentsDirectory;

  Future<Iterable<DataSnapshot>> getdata() async {
    DataSnapshot healthRecordRef = await database
        .child("health-record")
        .child(this.widget.partnerEntry.uid)
        .get();
    Iterable<DataSnapshot> a = healthRecordRef.children;
    return a;
  }

  Future<String> downloadFile(String uniquePushID, String filename) async {
    String result = "false";
    try {
      _externalDocumentsDirectory = await getExternalStorageDirectory();
      print(_externalDocumentsDirectory!.path);
    } on Exception catch (e) {
      print(e);
      return result;
    }
    File downloadToFile =
        File('${_externalDocumentsDirectory!.path}/$filename');
    try {
      await storage
          .child('health-record')
          .child(uniquePushID)
          .child('/' + uniquePushID)
          .writeToFile(downloadToFile);

      result = '${_externalDocumentsDirectory!.path}/$filename';
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print('Download error: $e');
    }
    return result;
  }

  late Future<Iterable<DataSnapshot>> streamData;

  bool basicEntry = true;
  @override
  Widget build(BuildContext context) {
    Future<Iterable<DataSnapshot>> streamData = getdata();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Rekam Medis Partner"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh Halaman',
            onPressed: () {
              setState(() {
                streamData = getdata();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        displacement: 18,
        onRefresh: () {
          setState(() {
            streamData = getdata();
          });
          return getdata();
        },
        child: FutureBuilder<Iterable<DataSnapshot>>(
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
              } else if (snapshot.data!.isEmpty) {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/health_record_screen.png",
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Rekam medis partner kamu masih kosong. Partner kamu belum menambahkan rekam medis pertamanya.",
                        style: const TextStyle(
                            color: kBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
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
                Iterable<DataSnapshot>? healthRecordData = snapshot.data!;

                return Container(
                  child: ListView(
                    children: [
                      for (DataSnapshot healthRecordSnapshot
                          in healthRecordData)
                        ExpansionTile(
                          title: Builder(builder: (BuildContext context) {
                            Widget child = Text("Memuat...",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ));
                            for (DataSnapshot itemSnapshot
                                in healthRecordSnapshot.children) {
                              if (itemSnapshot.key.toString() == "name") {
                                child = Text(
                                  itemSnapshot.value.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }
                            }

                            return child;
                          }),
                          subtitle: Row(
                            children: [
                              Text(
                                healthRecordSnapshot.key!,
                                style: TextStyle(
                                  color: Colors.black54,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              for (DataSnapshot itemSnapshot
                                  in healthRecordSnapshot.children)
                                if (itemSnapshot.key.toString() ==
                                    "creationdate")
                                  Text(
                                    itemSnapshot.value.toString(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                            ],
                          ),
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Card(
                                      color: kLightBlue2,
                                      elevation: 4,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      PartnerHealthRecordEntryScreen(
                                                        healthRecord:
                                                            healthRecordSnapshot,
                                                        partnerEntry: this
                                                            .widget
                                                            .partnerEntry,
                                                      )))
                                              .whenComplete(() {
                                            setState(() {
                                              streamData = getdata();
                                            });
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                          "Buka",
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
                            SizedBox(
                              height: 10,
                            ),
                            for (DataSnapshot itemSnapshot
                                in healthRecordSnapshot.children)
                              if (itemSnapshot.key.toString() != "name")
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child:
                                      Builder(builder: (BuildContext context) {
                                    Icon icons = Icon(
                                      Icons.settings,
                                      color: kBlack,
                                    );
                                    int? maxLines = 1;
                                    String title = "Not defined";
                                    if (itemSnapshot.key.toString() ==
                                        "location") {
                                      icons = Icon(
                                        Icons.location_on_outlined,
                                        color: kBlack,
                                      );
                                      title = "Lokasi";
                                      return TextFormField(
                                        autofocus: false,
                                        readOnly: true,
                                        maxLines: maxLines,
                                        controller: TextEditingController(
                                            text:
                                                itemSnapshot.value.toString()),
                                        style: TextStyle(color: kBlack),
                                        decoration: InputDecoration(
                                          prefixIcon: icons,
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none,
                                          labelText: title,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                        ),
                                      );
                                    } else if (itemSnapshot.key.toString() ==
                                        "description") {
                                      icons = Icon(
                                        Icons.list_alt_outlined,
                                        color: kBlack,
                                      );
                                      title = "Deskripsi";
                                      maxLines = null;
                                      return TextFormField(
                                        autofocus: false,
                                        readOnly: true,
                                        maxLines: maxLines,
                                        controller: TextEditingController(
                                            text:
                                                itemSnapshot.value.toString()),
                                        style: TextStyle(color: kBlack),
                                        decoration: InputDecoration(
                                          prefixIcon: icons,
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none,
                                          labelText: title,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                        ),
                                      );
                                    } else if (itemSnapshot.key.toString() ==
                                        "tag") {
                                      icons = Icon(
                                        Icons.tag,
                                        color: kBlack,
                                      );
                                      title = "Tag";
                                      return TextFormField(
                                        autofocus: false,
                                        readOnly: true,
                                        maxLines: maxLines,
                                        controller: TextEditingController(
                                            text:
                                                itemSnapshot.value.toString()),
                                        style: TextStyle(color: kBlack),
                                        decoration: InputDecoration(
                                          prefixIcon: icons,
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none,
                                          labelText: title,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                        ),
                                      );
                                    }
                                    return Container();
                                  }),
                                ),
                          ],
                        ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
