import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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
  List<StreamSubscription> customColumnStream = [];
  List<TextEditingController> keyControllers = [];
  List<TextEditingController> valueControllers = [];
  List<TextEditingController> attachmentController = [];
  List<String> customColumnKey = [];
  List<String> attachmentValue = [];
  String displayTextCreationDate = "Memuat...";
  String displayTextDescription = "Memuat...";
  String displayTextFilename = "Memuat...";
  String displayTextLocation = "Memuat...";
  String displayTextName = "Memuat...";
  String displayTextTag = "Memuat...";
  int attachmentCount = 0;

  Directory? _externalDocumentsDirectory;

  bool attachmentFile = false;
  Future<Iterable<DataSnapshot>> getdata() async {
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
    Directory('${_externalDocumentsDirectory!.path}/Rekam Medis/$uniquePushID')
        .createSync(recursive: true);
    Directory directoryToFile = Directory(
        '${_externalDocumentsDirectory!.path}/Rekam Medis/$uniquePushID');

    File downloadToFile = File(directoryToFile.path + "/" + filename);
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
    basicColumnStream.add(database
        .child('health-record')
        .child(this.widget.partnerEntry.uid)
        .child(this.widget.healthRecord.key!)
        .child("creationdate")
        .onValue
        .listen((event) {
      final Object? itemData = event.snapshot.value;
      setState(() {
        displayTextCreationDate = itemData.toString();
      });
    }));

    basicColumnStream.add(database
        .child('health-record')
        .child(this.widget.partnerEntry.uid)
        .child(this.widget.healthRecord.key!)
        .child("description")
        .onValue
        .listen((event) {
      final Object? itemData = event.snapshot.value;
      setState(() {
        displayTextDescription = itemData.toString();
      });
    }));

    basicColumnStream.add(database
        .child('health-record')
        .child(this.widget.partnerEntry.uid)
        .child(this.widget.healthRecord.key!)
        .child("location")
        .onValue
        .listen((event) {
      final Object? itemData = event.snapshot.value;
      setState(() {
        displayTextLocation = itemData.toString();
      });
    }));

    basicColumnStream.add(database
        .child('health-record')
        .child(this.widget.partnerEntry.uid)
        .child(this.widget.healthRecord.key!)
        .child("name")
        .onValue
        .listen((event) {
      final Object? itemData = event.snapshot.value;
      setState(() {
        displayTextName = itemData.toString();
      });
    }));

    basicColumnStream.add(database
        .child('health-record')
        .child(this.widget.partnerEntry.uid)
        .child(this.widget.healthRecord.key!)
        .child("tag")
        .onValue
        .listen((event) {
      final Object? itemData = event.snapshot.value;
      setState(() {
        displayTextTag = itemData.toString();
      });
    }));

    for (DataSnapshot itemData in this.widget.healthRecord.children) {
      if (itemData.key != "creationdate" &&
          itemData.key != "description" &&
          !itemData.key.toString().startsWith("filename") &&
          itemData.key != "location" &&
          itemData.key != "name" &&
          itemData.key != "tag") {
        customColumnKey.add(itemData.key.toString());
        setState(() {
          keyControllers.add(TextEditingController());
          valueControllers.add(TextEditingController());
        });
      } else if (itemData.key!.startsWith("filename")) {
        attachmentCount++;
        setState(() {
          attachmentValue.add(itemData.value.toString());
          attachmentController
              .add(TextEditingController(text: itemData.value.toString()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController idController =
        new TextEditingController(text: this.widget.healthRecord.key);
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
        labelText: "ID Rekam Medis - Tetap",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController nameController =
        new TextEditingController(text: displayTextName);
    final nameField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Mohon nama rekam medis anda.");
        }
        return null;
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
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

    DateTime selectedDate = DateTime.now();
    final TextEditingController dateController = new TextEditingController(
        text:
            displayTextCreationDate); //"${selectedDate.toLocal()}".split(' ')[0]
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1900, 1),
          lastDate: DateTime.now());
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
      }
      dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }

    final dateField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: dateController,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Masukkan tanggal rekam medis.");
        }

        return null;
      },
      onTap: () => _selectDate(context),
      onSaved: (value) {
        dateController.text = value!;
      },
      textInputAction: TextInputAction.next,
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

    final TextEditingController locationController =
        new TextEditingController(text: displayTextLocation);
    final locationField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: locationController,
      keyboardType: TextInputType.text,
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

    final TextEditingController descriptionController =
        new TextEditingController(text: displayTextDescription);
    final descriptionField = TextFormField(
      readOnly: true,
      maxLines: null,
      autofocus: false,
      controller: descriptionController,
      keyboardType: TextInputType.text,
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

    final TextEditingController tagController =
        new TextEditingController(text: displayTextTag);
    final tagField = TextFormField(
      readOnly: true,
      autofocus: false,
      controller: tagController,
      keyboardType: TextInputType.text,
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
                if (attachmentController.isNotEmpty)
                  for (int i = 0; i < attachmentController.length; i++)
                    Builder(builder: (context2) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: TextFormField(
                            readOnly: true,
                            autofocus: false,
                            controller: attachmentController[i],
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
                          Row(
                            children: [
                              IconButton(
                                  padding: EdgeInsets.only(top: 8),
                                  onPressed: () async {
                                    final snackBar = SnackBar(
                                      content: const Text("Sedang memuat...",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: kYellow,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    String result = await downloadAttachment(
                                        this.widget.healthRecord.key!,
                                        attachmentController[i].text);
                                    print(result);
                                    if (result != "false") {
                                      OpenFile.open(result);
                                    } else {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Download gagal, silahkan cek koneksi anda.",
                                            style:
                                                TextStyle(color: Colors.black)),
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
                        ],
                      );
                    }),
                Divider(
                  color: Colors.black54,
                ),
                if (customColumnKey.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 10, bottom: 5),
                    child: Row(
                      children: [
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
                      ],
                    ),
                  ),
                if (customColumnKey.isNotEmpty)
                  for (int i = 0; i < customColumnKey.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: FutureBuilder<DataSnapshot>(
                          future: database
                              .child('health-record')
                              .child(this.widget.partnerEntry.uid)
                              .child(this.widget.healthRecord.key!)
                              .child(customColumnKey[i])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              keyControllers[i].text = customColumnKey[i];
                              if (keyControllers[i].text != "") {
                                valueControllers[i].text =
                                    snapshot.data!.value.toString();
                              } else {
                                valueControllers[i].text = "";
                              }

                              return Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      autofocus: false,
                                      controller: keyControllers[i],
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(color: kBlack),
                                      decoration: InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
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
                                      controller: valueControllers[i],
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(color: kBlack),
                                      decoration: InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        border: InputBorder.none,
                                        labelText: "Value",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }),
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
