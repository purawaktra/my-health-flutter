import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/add_health_record.dart';
import 'package:myhealth/Screens/edit_health_record.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:share_plus/share_plus.dart';

class HealthRecordScreen extends StatefulWidget {
  const HealthRecordScreen({Key? key}) : super(key: key);
  @override
  _HealthRecordScreenState createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();
  Directory? _externalDocumentsDirectory;

  Future<Iterable<DataSnapshot>> getdata() async {
    DataSnapshot healthRecordRef = await database
        .child("health-record")
        .child(user.uid)
        .limitToFirst(20)
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

  String displayTextID = "go";
  @override
  Widget build(BuildContext context) {
    Future<Iterable<DataSnapshot>> streamData = getdata();
    setState(() {
      displayTextID = "Letsgo";
    });

    return Background(
        title: "Rekam Medisku",
        description: Text("Deskripsi kosong."),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => AddHealthRecordScreen()))
                        .whenComplete(() {
                      setState(() {
                        streamData = getdata();
                      });
                    }),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Card(
                            color: kLightBlue2,
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add_box_outlined,
                                  color: kBlack,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rekam Medis Baru',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "Dapat berupa gambar, foto, atau dokumen.",
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        streamData = getdata();
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Card(
                            color: kLightBlue2,
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.refresh_outlined,
                                  color: kBlack,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Muat Ulang',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "Mengunduh rekam medis terbaru.",
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Divider(
                color: kDarkBlue,
              ),
            ),
            FutureBuilder<Iterable<DataSnapshot>>(
                future: streamData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    Iterable<DataSnapshot>? healthRecordData = snapshot.data!;
                    return Column(
                      verticalDirection: VerticalDirection.up,
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
                                  in healthRecordSnapshot.children)
                                if (itemSnapshot.key.toString() == "name")
                                  child = Text(
                                    itemSnapshot.value.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                              return child;
                            }),
                            subtitle: Text(
                              healthRecordSnapshot.key!,
                              style: TextStyle(
                                color: Colors.black54,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                                        child: TapDebouncer(
                                          onTap: () async {
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  "Sedang memuat...",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              backgroundColor: kYellow,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);

                                            for (DataSnapshot itemSnapshot2
                                                in healthRecordSnapshot
                                                    .children)
                                              if (itemSnapshot2.key
                                                      .toString() ==
                                                  "filename") {
                                                String result =
                                                    await downloadFile(
                                                        healthRecordSnapshot
                                                            .key!,
                                                        itemSnapshot2.value
                                                            .toString());
                                                print(result);
                                                if (result != "false") {
                                                  Share.shareFiles([result]);
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        "Download berhasil.",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    backgroundColor: kYellow,
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else {
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        "Download gagal, silahkan cek koneksi anda.",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    backgroundColor: kYellow,
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              }
                                          },
                                          builder: (BuildContext context,
                                              TapDebouncerFunc? onTap) {
                                            return InkWell(
                                              onTap: onTap,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.save_alt_outlined,
                                                    color: kBlack,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
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
                                                        EditHealthRecordScreen(
                                                          healthRecord:
                                                              healthRecordSnapshot,
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
                                                Icons.edit,
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
                                                      color: Colors.black)),
                                              backgroundColor: kYellow,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                          onDoubleTap: () async {
                                            try {
                                              await storage
                                                  .child('health-record')
                                                  .child(
                                                      healthRecordSnapshot.key!)
                                                  .child(
                                                      healthRecordSnapshot.key!)
                                                  .delete();
                                              await database
                                                  .child("health-record")
                                                  .child(user.uid)
                                                  .child(
                                                      healthRecordSnapshot.key!)
                                                  .remove();
                                              final snackBar = SnackBar(
                                                content: const Text(
                                                    "Hapus berhasil.",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                backgroundColor: kYellow,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              setState(() {
                                                streamData = getdata();
                                              });
                                            } catch (e) {
                                              print(e.toString());
                                              final snackBar = SnackBar(
                                                content: const Text(
                                                    "Hapus gagal, cek koneksi anda.",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                backgroundColor: kYellow,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                            "Unduh, edit, dan hapus rekam medis.",
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
                                    child: Builder(
                                        builder: (BuildContext context) {
                                      Icon icons = Icon(
                                        Icons.settings,
                                        color: kBlack,
                                      );
                                      int? maxLines = 1;
                                      String title = "Not defined";
                                      if (itemSnapshot.key.toString() ==
                                          "filename") {
                                        icons = Icon(
                                          Icons.description_outlined,
                                          color: kBlack,
                                        );
                                        title = "Nama File";
                                      } else if (itemSnapshot.key.toString() ==
                                          "creationdate") {
                                        icons = Icon(
                                          Icons.date_range_outlined,
                                          color: kBlack,
                                        );
                                        title = "Tanggal";
                                      } else if (itemSnapshot.key.toString() ==
                                          "location") {
                                        icons = Icon(
                                          Icons.location_on_outlined,
                                          color: kBlack,
                                        );
                                        title = "Lokasi";
                                      } else if (itemSnapshot.key.toString() ==
                                          "description") {
                                        icons = Icon(
                                          Icons.list_alt_outlined,
                                          color: kBlack,
                                        );
                                        title = "Deskripsi";
                                        maxLines = null;
                                      } else if (itemSnapshot.key.toString() ==
                                          "tag") {
                                        icons = Icon(
                                          Icons.tag,
                                          color: kBlack,
                                        );
                                        title = "Tag";
                                      }
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
                                          hintText: title,
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none,
                                          labelText: title,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      );
                                    }),
                                  ),
                            ],
                          )
                      ],
                    );
                  }
                })
          ]),
        ));
  }
}
