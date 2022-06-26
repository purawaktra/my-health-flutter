import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PartnerHealthRecordEntryScreen extends StatefulWidget {
  final DataSnapshot healthRecord;
  final AccessEntry partnerEntry;
  const PartnerHealthRecordEntryScreen(
      {Key? key, required this.healthRecord, required this.partnerEntry})
      : super(key: key);

  @override
  _PartnerHealthRecordEntryScreenState createState() =>
      _PartnerHealthRecordEntryScreenState();
}

class _PartnerHealthRecordEntryScreenState
    extends State<PartnerHealthRecordEntryScreen> {
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();

  List<StreamSubscription> basicColumnStream = [];
  List<TextEditingController> keyControllersList = [];
  List<TextEditingController> valueControllersList = [];
  List<TextEditingController> attachmentControllerList = [];

  Directory? _externalDocumentsDirectory;

  bool attachmentFile = false;

  TextEditingController idController = new TextEditingController();
  TextEditingController nameController =
      new TextEditingController(text: "Memuat");
  TextEditingController dateController = new TextEditingController(
      text: "Memuat"); //"${selectedDate.toLocal()}".split(' ')[0]
  TextEditingController locationController =
      new TextEditingController(text: "Memuat");
  TextEditingController descriptionController =
      new TextEditingController(text: "Memuat");
  TextEditingController tagController =
      new TextEditingController(text: "Memuat");

  Future<Iterable<DataSnapshot>> getMetaData() async {
    DataSnapshot healthRecordRef = await database
        .child("health-record")
        .child(this.widget.partnerEntry.uid)
        .get();
    Iterable<DataSnapshot> a = healthRecordRef.children;
    return a;
  }

  Future<String> downloadAttachment(
      String uniquePushID, String filename) async {
    String result = "false";
    try {
      _externalDocumentsDirectory = await getExternalStorageDirectory();
      print(_externalDocumentsDirectory!.path);
    } on Exception catch (e) {
      print(e);
      return result;
    } catch (e) {
      print(e);
    }
    Directory(
            '${_externalDocumentsDirectory!.path}/Rekam Medis Partner/${this.widget.partnerEntry.uid}/$uniquePushID')
        .createSync(recursive: true);
    Directory directoryToFile = Directory(
        '${_externalDocumentsDirectory!.path}/Rekam Medis Partner/${this.widget.partnerEntry.uid}/$uniquePushID');

    File downloadToFile =
        File(directoryToFile.path + "/" + p.basename(filename));
    try {
      await storage
          .child('health-record')
          .child(this.widget.partnerEntry.uid)
          .child('/' + uniquePushID)
          .child('/' + filename)
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
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _activateListener();
  }

  void _activateListener() {
    setState(() {
      idController.text = this.widget.healthRecord.key.toString();
    });

    for (DataSnapshot itemData in this.widget.healthRecord.children) {
      print(itemData.key);
      if (itemData.key == "creationdate") {
        setState(() {
          dateController.text = itemData.value.toString();
        });
      } else if (itemData.key == "description") {
        setState(() {
          descriptionController.text = itemData.value.toString();
        });
      } else if (itemData.key == "location") {
        setState(() {
          locationController.text = itemData.value.toString();
        });
      } else if (itemData.key == "name") {
        setState(() {
          nameController.text = itemData.value.toString();
        });
      } else if (itemData.key == "tag") {
        setState(() {
          tagController.text = itemData.value.toString();
        });
      } else if (itemData.key!.startsWith("filename")) {
        setState(() {
          attachmentControllerList
              .add(TextEditingController(text: itemData.value.toString()));
        });
      } else if (itemData.key!.startsWith("customkey")) {
        setState(() {
          keyControllersList
              .add(TextEditingController(text: itemData.value.toString()));
        });
      } else if (itemData.key!.startsWith("customvalue")) {
        setState(() {
          valueControllersList
              .add(TextEditingController(text: itemData.value.toString()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final idField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: idController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.description_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "ID Rekam Medis",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final nameField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: nameController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.description_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Nama",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final dateField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: dateController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.date_range_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Tanggal",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final locationField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: locationController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Lokasi",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final descriptionField = TextFormField(
      readOnly: true,
      maxLines: null,
      autofocus: false,
      controller: descriptionController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.list_alt_outlined,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Deskripsi",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final tagField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: tagController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.tag,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Tag",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Rekam Medis Entry"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 10, bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        'Rekam Medis',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kLightBlue1,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                idField,
                dateField,
                nameField,
                locationField,
                descriptionField,
                tagField,
                if (attachmentControllerList.isNotEmpty)
                  for (MapEntry<int, TextEditingController> attachmentController
                      in attachmentControllerList.asMap().entries)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: TextFormField(
                          readOnly: true,
                          autofocus: false,
                          controller: attachmentController.value,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: kBlack),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.attach_file_outlined,
                              color: kBlack,
                            ),
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                            labelText: "Lampiran",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        )),
                        IconButton(
                            padding: EdgeInsets.only(top: 8),
                            onPressed: () async {
                              final snackBar = SnackBar(
                                content: const Text("Sedang memuat...",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              String result = await downloadAttachment(
                                  this.widget.healthRecord.key.toString(),
                                  attachmentController.value.text);
                              print(result);
                              if (result != "false") {
                                OpenFile.open(result);
                              } else {
                                final snackBar = SnackBar(
                                  content: const Text(
                                      "Download gagal, silahkan cek koneksi anda.",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: kYellow,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            icon: Icon(
                              Icons.file_open_outlined,
                              color: Colors.black54,
                              size: 24,
                            ))
                      ],
                    ),
                Divider(
                  color: Colors.black54,
                ),
                Text(
                  'Kolom Kustom',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kLightBlue1,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                if (keyControllersList.isNotEmpty)
                  for (MapEntry<int, TextEditingController> keyController
                      in keyControllersList.asMap().entries)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              readOnly: true,
                              autofocus: false,
                              controller:
                                  valueControllersList[keyController.key],
                              style: TextStyle(color: kBlack),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none,
                                labelText: "Key",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              maxLines: null,
                              autofocus: false,
                              controller: keyController.value,
                              style: TextStyle(color: kBlack),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none,
                                labelText: "Value",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    for (StreamSubscription item in basicColumnStream) {
      item.cancel();
    }
    super.deactivate();
  }
}
