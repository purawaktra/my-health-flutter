import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/components/health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:path/path.dart' as p;

enum OptionMenu { export, delete }

class HealthRecordEntryScreen extends StatefulWidget {
  final String healthRecordKey;
  const HealthRecordEntryScreen({Key? key, required this.healthRecordKey})
      : super(key: key);

  @override
  _HealthRecordEntryScreenState createState() =>
      _HealthRecordEntryScreenState();
}

class _HealthRecordEntryScreenState extends State<HealthRecordEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();
  late OptionMenu _selection;

  List<StreamSubscription> basicColumnStream = [];
  List<TextEditingController> keyControllersList = [];
  List<TextEditingController> valueControllersList = [];
  List<TextEditingController> attachmentControllerList = [];
  String displayTextFilename = "Memuat...";

  bool basicColumnEditState = false;

  bool customColumnEditState = false;

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
        .child(user.uid)
        .child(this.widget.healthRecordKey)
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

    File downloadToFile =
        File(directoryToFile.path + "/" + p.basename(filename));
    try {
      await storage
          .child('health-record')
          .child(user.uid)
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

  Future<bool> uploadAttachment(String path) async {
    final snackBar = SnackBar(
      content: const Text("Mengunggah.", style: TextStyle(color: Colors.black)),
      backgroundColor: kYellow,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    bool status = false;
    try {
      Reference attachmentRef = FirebaseStorage.instance
          .ref()
          .child('health-record')
          .child(user.uid)
          .child(this.widget.healthRecordKey)
          .child('/' + p.basename(path));
      try {
        await attachmentRef.putData(await File(path).readAsBytes());
        status = true;
      } catch (e) {
        print(e);
        try {
          await attachmentRef.putFile(File(path));
          status = true;
        } catch (e) {
          print(e);
        }
      }
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

      await uploadAttachment(image!.path);

      setState(() {
        attachmentControllerList.add(TextEditingController(text: image.path));
      });
      DatabaseReference pushIDref = database
          .child("health-record")
          .child(user.uid)
          .child(this.widget.healthRecordKey.toString());
      for (MapEntry<int, TextEditingController> attachmentController
          in attachmentControllerList.asMap().entries) {
        await pushIDref.update({
          "filename-${attachmentController.key}":
              attachmentController.value.text,
        });
      }
      status = true;
    } catch (e) {
      print(e);
    }
    return status;
  }

  Future<bool> pickFile() async {
    bool status = false;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      await uploadAttachment(result!.files.single.path.toString());

      setState(() {
        attachmentControllerList.add(
            TextEditingController(text: result.files.single.path.toString()));
      });
      DatabaseReference pushIDref = database
          .child("health-record")
          .child(user.uid)
          .child(this.widget.healthRecordKey.toString());
      for (MapEntry<int, TextEditingController> attachmentController
          in attachmentControllerList.asMap().entries) {
        await pushIDref.update({
          "filename-${attachmentController.key}":
              attachmentController.value.text,
        });
      }
      status = true;
    } catch (e) {
      print(e);
    }
    return status;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _activateListener();
  }

  Future<void> _activateListener() async {
    Iterable<DataSnapshot> metaDataSnapshot = await getMetaData();
    idController.text = this.widget.healthRecordKey;

    for (DataSnapshot itemData in metaDataSnapshot) {
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
      enabled: false,
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
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
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
      readOnly: true,
      autofocus: false,
      controller: dateController,
      style: TextStyle(color: kBlack),
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );

    final locationField = TextFormField(
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
      autofocus: false,
      controller: locationController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      textInputAction: TextInputAction.next,
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
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
      maxLines: null,
      autofocus: false,
      controller: descriptionController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      textInputAction: TextInputAction.next,
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
      enabled: basicColumnEditState,
      readOnly: !basicColumnEditState,
      autofocus: false,
      controller: tagController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      textInputAction: TextInputAction.next,
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
                    .child(this.widget.healthRecordKey)
                    .get();
                final healthRecordExport =
                    HealthRecordEntry(this.widget.healthRecordKey);
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
                        '${_externalDocumentsDirectory!.path}/Rekam Medis/${this.widget.healthRecordKey}')
                    .createSync(recursive: true);

                File fileToMetaData = File(
                    "${_externalDocumentsDirectory!.path}/Rekam Medis/${this.widget.healthRecordKey}/metadata-export.txt");

                fileToMetaData
                    .writeAsString(healthRecordExport.toJson().toString());

                String result = "false";
                for (DataSnapshot itemSnapshot2 in ref.children) {
                  if (itemSnapshot2.key.toString().startsWith("filename")) {
                    result = await downloadAttachment(
                        this.widget.healthRecordKey,
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
                        "${_externalDocumentsDirectory!.path}/Rekam Medis/${this.widget.healthRecordKey}.zip");
                    ZipFile.createFromDirectory(
                      sourceDir: Directory(
                          "${_externalDocumentsDirectory!.path}/Rekam Medis/${this.widget.healthRecordKey}"),
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
                        .child(user.uid)
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
          child: Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 10, bottom: 5),
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
                            if (!basicColumnEditState) {
                              setState(() {
                                basicColumnEditState = !basicColumnEditState;
                              });
                              final snackBar = SnackBar(
                                content: const Text("Edit rekam medis.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  basicColumnEditState = !basicColumnEditState;
                                });
                                try {
                                  DatabaseReference pushIDref = database
                                      .child("health-record")
                                      .child(user.uid)
                                      .child(this
                                          .widget
                                          .healthRecordKey
                                          .toString());

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
                              } else {
                                final snackBar = SnackBar(
                                  content: const Text("Form tidak valid.",
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
                  if (attachmentControllerList.isNotEmpty)
                    for (MapEntry<int,
                            TextEditingController> attachmentController
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
                          !basicColumnEditState
                              ? Row(
                                  children: [
                                    IconButton(
                                        padding: EdgeInsets.only(top: 8),
                                        onPressed: () async {
                                          final snackBar = SnackBar(
                                            content: const Text("Memuat...",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            backgroundColor: kYellow,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          String result =
                                              await downloadAttachment(
                                                  this.widget.healthRecordKey,
                                                  attachmentController
                                                      .value.text);
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
                                    IconButton(
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
                                                  this.widget.healthRecordKey,
                                                  attachmentController
                                                      .value.text);
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
                                  ],
                                )
                              : IconButton(
                                  padding: EdgeInsets.only(top: 8),
                                  onPressed: () async {
                                    try {
                                      await storage
                                          .child('health-record')
                                          .child(user.uid)
                                          .child(idController.text)
                                          .child(p.basename(
                                              attachmentController.value.text))
                                          .delete();
                                    } catch (e) {
                                      print(e);
                                    }

                                    DatabaseReference pushIDref = database
                                        .child("health-record")
                                        .child(user.uid)
                                        .child(this
                                            .widget
                                            .healthRecordKey
                                            .toString());
                                    for (int a = 0;
                                        a < attachmentControllerList.length;
                                        a++) {
                                      await pushIDref
                                          .child("filename-$a")
                                          .remove();
                                    }
                                    setState(() {
                                      attachmentControllerList
                                          .remove(attachmentController.value);
                                    });

                                    for (MapEntry<int,
                                            TextEditingController> attachmentController1
                                        in attachmentControllerList
                                            .asMap()
                                            .entries) {
                                      await pushIDref.update({
                                        "filename-${attachmentController1.key}":
                                            attachmentController1.value.text,
                                      });
                                    }
                                    final snackBar = SnackBar(
                                      content: const Text("Lampiran dihapus.",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: kYellow,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 24,
                                  )),
                        ],
                      ),
                  if (basicColumnEditState)
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext alertContext) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TapDebouncer(onTap: () async {
                                      Navigator.of(alertContext).pop();
                                      bool status =
                                          await pickImage(ImageSource.camera);

                                      if (status) {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Lampiran ditambahkan.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        final snackBar = SnackBar(
                                          content: const Text("Dibatalkan.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }, builder: (BuildContext context,
                                        TapDebouncerFunc? onTap) {
                                      return InkWell(
                                        onTap: onTap,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
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
                                      );
                                    }),
                                    TapDebouncer(onTap: () async {
                                      Navigator.of(alertContext).pop();
                                      bool status =
                                          await pickImage(ImageSource.gallery);

                                      if (status) {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Lampiran ditambahkan.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        final snackBar = SnackBar(
                                          content: const Text("Dibatalkan.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }, builder: (BuildContext context,
                                        TapDebouncerFunc? onTap) {
                                      return InkWell(
                                        onTap: onTap,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                      Icons
                                                          .photo_album_outlined,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
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
                                      );
                                    }),
                                    TapDebouncer(onTap: () async {
                                      Navigator.of(alertContext).pop();
                                      bool status = await pickFile();

                                      if (status) {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "Lampiran ditambahkan.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        final snackBar = SnackBar(
                                          content: const Text("Dibatalkan.",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: kYellow,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }, builder: (BuildContext context,
                                        TapDebouncerFunc? onTap) {
                                      return InkWell(
                                        onTap: onTap,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
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
                                ),
                              );
                            });
                      },
                      child: Text(
                        "Tambahkan lampiran",
                        style: TextStyle(color: kWhite),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kLightBlue1)),
                    ),
                  Divider(
                    color: Colors.black54,
                  ),
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
                        ElevatedButton(
                          onPressed: () async {
                            if (!customColumnEditState) {
                              setState(() {
                                customColumnEditState = !customColumnEditState;
                              });
                              final snackBar = SnackBar(
                                content: const Text("Edit rekam medis.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  customColumnEditState =
                                      !customColumnEditState;
                                });
                                try {
                                  DatabaseReference pushIDref = database
                                      .child("health-record")
                                      .child(user.uid)
                                      .child(this.widget.healthRecordKey);

                                  for (int i = 0;
                                      i < keyControllersList.length;
                                      i++) {
                                    print(keyControllersList[i].text);
                                    print(valueControllersList[i].text);
                                    await pushIDref.update({
                                      "customkey-$i":
                                          keyControllersList[i].text,
                                      "customvalue-$i":
                                          valueControllersList[i].text
                                    });
                                  }

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
                              } else {
                                final snackBar = SnackBar(
                                  content: const Text("Form isian masih kosong",
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
                                enabled: true,
                                readOnly: !customColumnEditState,
                                autofocus: false,
                                controller:
                                    valueControllersList[keyController.key],
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: kBlack),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("");
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none,
                                  labelText: "Key",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  errorStyle: TextStyle(height: 0),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: TextFormField(
                                enabled: true,
                                readOnly: !customColumnEditState,
                                maxLines: null,
                                autofocus: false,
                                controller: keyController.value,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: kBlack),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("");
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none,
                                  labelText: "Value",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  errorStyle: TextStyle(height: 0),
                                ),
                              ),
                            ),
                            customColumnEditState
                                ? TapDebouncer(onTap: () async {
                                    DatabaseReference pushIDref = database
                                        .child("health-record")
                                        .child(user.uid)
                                        .child(this.widget.healthRecordKey);
                                    for (int a = 0;
                                        a < keyControllersList.length;
                                        a++) {
                                      await pushIDref
                                          .child("customkey-$a")
                                          .remove();
                                    }

                                    for (int a = 0;
                                        a < valueControllersList.length;
                                        a++) {
                                      await pushIDref
                                          .child("customvalue-$a")
                                          .remove();
                                    }
                                    setState(() {
                                      keyControllersList
                                          .remove(keyController.value);
                                      valueControllersList
                                          .removeAt(keyController.key);
                                    });

                                    for (MapEntry<int,
                                            TextEditingController> keyController
                                        in keyControllersList.asMap().entries) {
                                      await pushIDref.update({
                                        "customkey-${keyController.key}":
                                            keyController.value.text,
                                      });
                                    }
                                    for (MapEntry<int,
                                            TextEditingController> valueController
                                        in valueControllersList
                                            .asMap()
                                            .entries) {
                                      await pushIDref.update({
                                        "customvalue-${valueController.key}":
                                            valueController.value.text,
                                      });
                                    }
                                  }, builder: (BuildContext context,
                                    TapDebouncerFunc? onTap) {
                                    return IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: onTap,
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                          size: 16,
                                        ));
                                  })
                                : Container(),
                          ],
                        ),
                      ),
                  customColumnEditState
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              keyControllersList
                                  .add(TextEditingController(text: ""));
                              valueControllersList
                                  .add(TextEditingController(text: ""));
                            });
                          },
                          child: Text(
                            "Tambahkan kolom kustom",
                            style: TextStyle(color: kWhite),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  kLightBlue1)),
                        )
                      : Container(),
                ],
              ),
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
