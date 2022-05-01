import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/add_health_record_basic_entry_screen.dart';
import 'package:myhealth/screens/add_health_record_entry_screen.dart';
import 'package:path/path.dart' as p;
import 'package:tap_debouncer/tap_debouncer.dart';

class AddHealthRecordScreen extends StatefulWidget {
  const AddHealthRecordScreen({Key? key}) : super(key: key);
  @override
  _AddHealthRecordScreenState createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  // late Future<File?> imageFile = Future.value(null);
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  File? filePicked;
  String filename = "null.dat";
  Future<bool> pickFile() async {
    bool status = false;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      final fileTemporary = File(result!.files.single.path.toString());
      setState(() {
        this.filePicked = fileTemporary;
        this.filename = result.files.single.name;
        print(this.filename);
      });
      status = true;
    } catch (e) {
      print(e);
    }
    return status;
  }

  Future<bool> pickImage(ImageSource source) async {
    bool status = false;
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      final imageTemporary = File(image!.path);
      setState(() {
        this.filePicked = imageTemporary;
        this.filename = p.basename(image.path);
      });
      status = true;
    } catch (e) {
      print(e);
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        title: "Rekam Medis Baru",
        description: Text("Deskripsi kosong."),
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddHealthRecordBasicEntryScreen()))
                                .whenComplete(
                                    () => Navigator.of(context).pop());
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.note_alt_outlined,
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
                                      'Basic',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "Upload rekam medis tanpa lampiran.",
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
                          onTap: () async {
                            bool status = await pickImage(ImageSource.camera);
                            if (status) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) =>
                                          HealthRecordEntryScreen(
                                            data: filePicked!,
                                          )))
                                  .whenComplete(
                                      () => Navigator.of(context).pop());
                            } else {
                              final snackBar = SnackBar(
                                content: const Text("Dibatalkan.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.camera_alt_outlined,
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
                                      'Buka Kamera',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "Foto rekam medis secara langsung.",
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
                          onTap: () async {
                            bool status = await pickImage(ImageSource.gallery);
                            if (status) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) =>
                                          HealthRecordEntryScreen(
                                            data: filePicked!,
                                          )))
                                  .whenComplete(
                                      () => Navigator.of(context).pop());
                            } else {
                              final snackBar = SnackBar(
                                content: const Text("Dibatalkan.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.photo_album_outlined,
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
                                      'Pilih Photo',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "Ambil photo dari galeri android.",
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
                        TapDebouncer(onTap: () async {
                          bool status = await pickFile();
                          if (status) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        HealthRecordEntryScreen(
                                          data: filePicked!,
                                        )))
                                .whenComplete(
                                    () => Navigator.of(context).pop());
                          } else {
                            final snackBar = SnackBar(
                              content: const Text("Dibatalkan.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }, builder:
                            (BuildContext context, TapDebouncerFunc? onTap) {
                          return InkWell(
                            onTap: onTap,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.storage_outlined,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pilih File',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "Ambil file dari penyimpanan android.",
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    )))));
  }
}
