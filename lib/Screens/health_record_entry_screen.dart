import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_archive/flutter_archive.dart';

enum OptionMenu { export, delete }

class HealthRecordEntryScreen extends StatefulWidget {
  final DataSnapshot healthRecord;
  const HealthRecordEntryScreen({Key? key, required this.healthRecord})
      : super(key: key);

  @override
  _HealthRecordEntryScreenState createState() =>
      _HealthRecordEntryScreenState();
}

class _HealthRecordEntryScreenState extends State<HealthRecordEntryScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();
  late OptionMenu _selection;

  List<StreamSubscription> basicColumnStream = [];
  List<StreamSubscription> customColumnStream = [];
  List<String> customColumnKey = [];
  List<String> attachmentKey = [];
  String displayTextCreationDate = "Memuat...";
  String displayTextDescription = "Memuat...";
  String displayTextFilename = "Memuat...";
  String displayTextLocation = "Memuat...";
  String displayTextName = "Memuat...";
  String displayTextTag = "Memuat...";

  bool basicColumnEditState = false;

  bool customColumnEditState = false;

  List<String> keyRemove = [];
  Directory? _externalDocumentsDirectory;

  bool attachmentFile = false;
  Future<Iterable<DataSnapshot>> getdata() async {
    DataSnapshot healthRecordRef = await database
        .child("health-record")
        .child(user.uid)
        .limitToFirst(20)
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
    }
    Directory directoryToFile = await Directory(
            '${_externalDocumentsDirectory!.path}/Rekam Medis/$uniquePushID')
        .create();

    File downloadToFile = File(directoryToFile.path + "/" + filename);
    try {
      await storage
          .child('health-record')
          .child(user.uid)
          .child('/' + uniquePushID)
          .child('/' + filename)
          .writeToFile(downloadToFile);

      result = downloadToFile.path;
      print(result);
    } on FirebaseException catch (e) {
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
        .child(user.uid)
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
        .child(user.uid)
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
        .child(user.uid)
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
        .child(user.uid)
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
        .child(user.uid)
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
      } else if (itemData.key!.startsWith("filename")) {
        attachmentKey.add(itemData.value.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> keyControllers = [];
    List<TextEditingController> valueControllers = [];
    List<TextEditingController> attachmentController = [];

    final TextEditingController idController =
        new TextEditingController(text: this.widget.healthRecord.key);
    final idField = TextFormField(
      enabled: false,
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
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
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
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
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
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
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
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
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
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
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

    // final TextEditingController attachmentController =
    //     new TextEditingController(text: displayTextFilename);
    // final attachmentField = TextFormField(
    //   enabled: true,
    //   readOnly: true,
    //   autofocus: false,
    //   controller: attachmentController,
    //   keyboardType: TextInputType.text,
    //   style: TextStyle(color: kBlack),
    //   decoration: InputDecoration(
    //     prefixIcon: Icon(
    //       Icons.attach_file_outlined,
    //       color: kBlack,
    //     ),
    //     hintStyle: TextStyle(color: Colors.black54),
    //     border: InputBorder.none,
    //     labelText: "Lampiran",
    //     floatingLabelBehavior: FloatingLabelBehavior.auto,
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Rekam Medis Entry"),
        actions: <Widget>[
          PopupMenuButton<OptionMenu>(
            onSelected: (OptionMenu result) async {
              if (result.name == "export") {
                _externalDocumentsDirectory =
                    await getExternalStorageDirectory();
                final snackBar = SnackBar(
                  content: const Text("Memuat...",
                      style: TextStyle(color: Colors.black)),
                  backgroundColor: kYellow,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                var ref = await database
                    .child('health-record')
                    .child(user.uid)
                    .child(this.widget.healthRecord.key!)
                    .get();
                final healthRecordExport =
                    HealthRecordEntry(this.widget.healthRecord.key!);
                for (DataSnapshot itemSnapshot2 in ref.children) {
                  if (itemSnapshot2.key == "creationdate") {
                    healthRecordExport.creationDate =
                        itemSnapshot2.value.toString();
                  } else if (itemSnapshot2.key == "description") {
                    healthRecordExport.description =
                        itemSnapshot2.value.toString();
                  } else if (itemSnapshot2.key == "location") {
                    healthRecordExport.location =
                        itemSnapshot2.value.toString();
                  } else if (itemSnapshot2.key == "name") {
                    healthRecordExport.name = itemSnapshot2.value.toString();
                  } else if (itemSnapshot2.key == "tag") {
                    healthRecordExport.tag = itemSnapshot2.value.toString();
                  } else {
                    healthRecordExport.metaData[itemSnapshot2.key.toString()] =
                        itemSnapshot2.value.toString();
                  }
                }

                print(healthRecordExport.toJson());
                Directory(
                        '${_externalDocumentsDirectory!.path}/Rekam Medis/${this.widget.healthRecord.key}')
                    .createSync(recursive: true);

                File fileToMetaData = File(
                    "${_externalDocumentsDirectory!.path}/Rekam Medis/${this.widget.healthRecord.key}/metadata-export.txt");

                fileToMetaData
                    .writeAsString(healthRecordExport.toJson().toString());

                String result = "false";
                for (DataSnapshot itemSnapshot2 in ref.children) {
                  if (itemSnapshot2.key.toString().startsWith("filename")) {
                    result = await downloadAttachment(
                        this.widget.healthRecord.key!,
                        itemSnapshot2.value.toString());
                    if (result == "false") {
                      break;
                    }
                  }
                }

                print(result);
                if (result == "false") {
                  final snackBar = SnackBar(
                    content: const Text(
                        "Download gagal, silahkan cek koneksi anda.",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: kYellow,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  try {
                    final zipFile = File(
                        "${_externalDocumentsDirectory!.path}/Rekam Medis/${this.widget.healthRecord.key}.zip");
                    ZipFile.createFromDirectory(
                      sourceDir: Directory(
                          "${_externalDocumentsDirectory!.path}/Rekam Medis/${this.widget.healthRecord.key}"),
                      zipFile: zipFile,
                    );
                    Share.shareFiles([zipFile.path]);
                  } catch (e) {
                    print(e);
                  }
                }
              } else if (result.name == "delete") {
                try {
                  try {
                    await storage
                        .child('health-record')
                        .child(idController.text)
                        .child(idController.text)
                        .delete();
                  } catch (e) {
                    print(e);
                  }

                  await database
                      .child("health-record")
                      .child(user.uid)
                      .child(idController.text)
                      .remove();
                  final snackBar = SnackBar(
                    content: const Text("Hapus berhasil.",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: kYellow,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e.toString());
                  final snackBar = SnackBar(
                    content: const Text("Hapus gagal, cek koneksi anda.",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: kYellow,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<OptionMenu>>[
              const PopupMenuItem<OptionMenu>(
                value: OptionMenu.export,
                child: Text('Export sebagai..'),
              ),
              const PopupMenuItem<OptionMenu>(
                value: OptionMenu.delete,
                child: Text('Hapus'),
              ),
            ],
          ),
        ],
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
                      SizedBox(
                        width: 24,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            basicColumnEditState = !basicColumnEditState;
                          });
                          if (basicColumnEditState) {
                            final snackBar = SnackBar(
                              content: const Text("Edit rekam medis.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            try {
                              DatabaseReference pushIDref = database
                                  .child("health-record")
                                  .child(user.uid)
                                  .child(
                                      this.widget.healthRecord.key.toString());

                              await pushIDref.update({
                                "creationdate": dateController.text,
                                "description": descriptionController.text,
                                "location": locationController.text,
                                "name": nameController.text,
                                "tag": tagController.text,
                              });

                              final snackBar = SnackBar(
                                content: const Text("Tersimpan.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } catch (e) {
                              print(e);
                              final snackBar = SnackBar(
                                content: const Text(
                                    "Update gagal, cek koneksi internet.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        child: Text(
                          basicColumnEditState ? 'Simpan' : 'Edit',
                          style: TextStyle(color: kWhite),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kLightBlue1),
                            visualDensity: VisualDensity.compact),
                      )
                    ],
                  ),
                ),
                idField,
                dateField,
                nameField,
                locationField,
                descriptionField,
                tagField,
                for (int i = 0; i < attachmentKey.length; i++)
                  FutureBuilder<DataSnapshot>(
                      future: database
                          .child('health-record')
                          .child(user.uid)
                          .child(this.widget.healthRecord.key!)
                          .child(attachmentKey[i])
                          .get(),
                      builder: ((context2, snapshot) {
                        if (snapshot.hasData) {
                          attachmentController.add(TextEditingController(
                              text: snapshot.data!.value.toString()));
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                ),
                              )),
                              if (basicColumnEditState)
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
                                        Share.shareFiles([result]);
                                      } else {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Download gagal, silahkan cek koneksi anda.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.black54,
                                      size: 24,
                                    )),
                              basicColumnEditState
                                  ? IconButton(
                                      padding: EdgeInsets.only(top: 8),
                                      onPressed: () async {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Sedang memuat...",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        String result =
                                            await downloadAttachment(
                                                this.widget.healthRecord.key!,
                                                attachmentController[i].text);
                                        print(result);
                                        if (result != "false") {
                                          OpenFile.open(result);
                                        } else {
                                          final snackBar = SnackBar(
                                            content: const Text(
                                                "Download gagal, silahkan cek koneksi anda.",
                                                style: TextStyle(
                                                    color: Colors.black)),
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
                                  : IconButton(
                                      padding: EdgeInsets.only(top: 8),
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 24,
                                      )),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      })),

                Divider(
                  color: Colors.black54,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 10, bottom: 5),
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
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            customColumnEditState = !customColumnEditState;
                          });
                          if (customColumnEditState) {
                            final snackBar = SnackBar(
                              content: const Text("Edit rekam medis.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            try {
                              DatabaseReference pushIDref = database
                                  .child("health-record")
                                  .child(user.uid)
                                  .child(
                                      this.widget.healthRecord.key.toString());

                              for (int i = 0; i < keyControllers.length; i++) {
                                await pushIDref.update({
                                  keyControllers[i].text:
                                      valueControllers[i].text
                                });
                              }
                              print(keyRemove);
                              for (int i = 0; i < keyRemove.length; i++) {
                                await pushIDref.child(keyRemove[i]).remove();
                              }
                              print("a");

                              List<String> a = [];
                              DataSnapshot healthRecordEntry =
                                  await pushIDref.get();
                              Iterable<DataSnapshot> items =
                                  healthRecordEntry.children;
                              for (DataSnapshot item in items) {
                                if (item.key != "creationdate" &&
                                    item.key != "description" &&
                                    item.key != "filename" &&
                                    item.key != "location" &&
                                    item.key != "name" &&
                                    item.key != "tag") {
                                  a.add(item.key.toString());
                                }
                              }
                              setState(() {
                                customColumnKey = a;
                              });
                              print("a");

                              final snackBar = SnackBar(
                                content: const Text("Tersimpan.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } catch (e) {
                              print(e);
                              final snackBar = SnackBar(
                                content: const Text(
                                    "Update gagal, cek koneksi internet.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        child: Text(
                          customColumnEditState ? 'Simpan' : 'Edit',
                          style: TextStyle(color: kWhite),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kLightBlue1),
                            visualDensity: VisualDensity.compact),
                      )
                    ],
                  ),
                ),
                for (int i = 0; i < customColumnKey.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: FutureBuilder<DataSnapshot>(
                        future: database
                            .child('health-record')
                            .child(user.uid)
                            .child(this.widget.healthRecord.key!)
                            .child(customColumnKey[i])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
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
                                    enabled: customColumnEditState,
                                    readOnly: !customColumnEditState,
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
                                    enabled: customColumnEditState,
                                    readOnly: !customColumnEditState,
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
                                customColumnEditState
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            if (customColumnKey[i] != "") {
                                              keyRemove.add(customColumnKey[i]);
                                            }

                                            customColumnKey.removeAt(i);
                                            keyControllers.removeAt(i);
                                            valueControllers.removeAt(i);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                          size: 16,
                                        ))
                                    : Container(),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),

                customColumnEditState
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            keyControllers.add(TextEditingController(text: ""));
                            valueControllers
                                .add(TextEditingController(text: ""));
                            customColumnEditState = true;
                            customColumnKey.add("");
                          });
                        },
                        child: Text(
                          "Tambahkan kolom kustom",
                          style: TextStyle(color: kWhite),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kLightBlue1)),
                      )
                    : Container(),
                // InkWell(
                //   onTap: () async {
                //     final snackBar = SnackBar(
                //       content: const Text("Sedang memuat...",
                //           style: TextStyle(color: Colors.black)),
                //       backgroundColor: kYellow,
                //     );
                //     ScaffoldMessenger.of(context).showSnackBar(snackBar);

                //     try {
                //       DatabaseReference pushIDref = database
                //           .child("health-record")
                //           .child(user.uid)
                //           .child(displayTextID);
                //       await pushIDref.update({
                //         "creationdate": dateController.text,
                //         "description": descriptionController.text,
                //         "location": locationController.text,
                //         "name": nameController.text,
                //         "tag": tagController.text,
                //       }).whenComplete(() {
                //         final snackBar = SnackBar(
                //           content: const Text("Edit berhasil.",
                //               style: TextStyle(color: Colors.black)),
                //           backgroundColor: kYellow,
                //         );
                //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //         Navigator.of(context).pop();
                //       });
                //     } catch (e) {
                //       print(e);
                //       final snackBar = SnackBar(
                //         content: const Text("Edit gagal, cek koneksi internet.",
                //             style: TextStyle(color: Colors.black)),
                //         backgroundColor: kYellow,
                //       );
                //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //     }
                //   },
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       SizedBox(
                //         height: 80,
                //         width: 80,
                //         child: Card(
                //           color: kWhite,
                //           elevation: 4,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: <Widget>[
                //               Icon(
                //                 Icons.check_box_outlined,
                //                 color: kBlack,
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       Expanded(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'Selesai',
                //               style: TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 18,
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //             Text(
                //               "Pastikan data yang diubah telah benar. ",
                //               style: TextStyle(
                //                 color: Colors.black54,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
