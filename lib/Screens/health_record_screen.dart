import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/add_health_record.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';
import 'package:path_provider/path_provider.dart';

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
  String aa = "aa";

  late StreamSubscription userFullnameStream;
  String displayTextUserFullname = "Belum diatur";

  Future<Iterable<DataSnapshot>> getdata() async {
    DataSnapshot healthRecordRef = await database
        .child("health-record")
        .child(user.uid)
        .limitToFirst(2)
        .get();
    Iterable<DataSnapshot> a = healthRecordRef.children;
    // for (DataSnapshot imageSnapshot in a) {
    //   print(imageSnapshot.key.toString());
    // }
    return a;
  }

  bool _allowWriteFile = false;

  // @override
  // void initState() {
  //   super.initState();
  //   requestWritePermission();
  // }

// Platform messages are asynchronous, so we initialize in an async method.
//   requestWritePermission() async {
//     PermissionStatus permissionStatus =
//         await SimplePermissions.requestPermission(
//             Permission.WriteExternalStorage);

//     if (permissionStatus == PermissionStatus.authorized) {
//       setState(() {
//         _allowWriteFile = true;
//       });
//     }
//   }

  Future<bool> downloadFile(String uniquePushID, String name) async {
    //First you get the documents folder location on the device...
    bool result = false;
    try {
      _externalDocumentsDirectory = await getExternalStorageDirectory();
      print(_externalDocumentsDirectory!.path);
    } on Exception catch (e) {
      print(e);
      return result;
    }
    //Here you'll specify the file it should be saved as
    File downloadToFile =
        File('${_externalDocumentsDirectory!.path}/$name.jpg');
    //Here you'll specify the file it should download from Cloud Storage

    //Now you can try to download the specified file, and write it to the downloadToFile.
    try {
      await storage
          .child('health-record')
          .child(uniquePushID)
          .child('/' + name + ".jpg")
          .writeToFile(downloadToFile);
      result = true;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print('Download error: $e');
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        title: "Rekam Medisku",
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddHealthRecordScreen())),
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
                                  Icons.edit,
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
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => HealthRecordScreen())),
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
                future: getdata(),
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
                            title: StreamBuilder<DatabaseEvent>(
                                stream: database
                                    .child('health-record')
                                    .child(user.uid)
                                    .child(healthRecordSnapshot.key!)
                                    .child("name")
                                    .onValue,
                                builder: (context, snapshot) {
                                  Widget child;
                                  if (snapshot.hasError) {
                                    child = Text(
                                      healthRecordSnapshot.children.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  } else {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        child = Text(
                                          "Sedang memuat...",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                        break;
                                      case ConnectionState.waiting:
                                        child = Text(
                                          "Sedang memuat...",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                        break;
                                      case ConnectionState.active:
                                        child = Text(
                                          snapshot.data!.snapshot.value
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                        break;
                                      case ConnectionState.done:
                                        child = Text(
                                          snapshot.data!.snapshot.value
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                        break;
                                    }
                                  }
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
                                      String title = "Not defined";
                                      if (itemSnapshot.key.toString() ==
                                          "url") {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 8),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        "Sedang memuat...",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    backgroundColor: kYellow,
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  bool result =
                                                      await downloadFile(
                                                          healthRecordSnapshot
                                                              .key!,
                                                          healthRecordSnapshot
                                                              .key!);
                                                  if (result) {
                                                    final snackBar = SnackBar(
                                                      content: const Text(
                                                          "Download berhasil.",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      backgroundColor: kYellow,
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  } else {
                                                    final snackBar = SnackBar(
                                                      content: const Text(
                                                          "Download gagal, silahkan cek koneksi anda.",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      backgroundColor: kYellow,
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  }
                                                },
                                                child: Text(
                                                  "Download Rekam Medis",
                                                  style:
                                                      TextStyle(color: kWhite),
                                                )),
                                          ),
                                        );
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
                                  )
                            ],
                          )
                      ],
                    );
                    // return Flexible(
                    //     child: ListView.builder(
                    //         scrollDirection: Axis.vertical,
                    //         itemCount: 15,
                    //         itemBuilder: (BuildContext context, int index) {
                    //           return ExpansionTile(
                    //             title: Text(
                    //               "gg",
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 18,
                    //                 overflow: TextOverflow.ellipsis,
                    //               ),
                    //             ),
                    //             subtitle: Text(
                    //               'Trailing expansion arrow icon',
                    //               style: TextStyle(
                    //                 color: Colors.black54,
                    //                 overflow: TextOverflow.ellipsis,
                    //               ),
                    //             ),
                    //             children: <Widget>[
                    //               ListTile(title: Text('This is tile number 1')),
                    //             ],
                    //           );
                    //         }));
                  }
                })
          ]),
        ));
  }
}
