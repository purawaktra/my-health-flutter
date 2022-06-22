import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myhealth/constants.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:path/path.dart' as p;

class AddHealthRecordEntryScreen extends StatefulWidget {
  const AddHealthRecordEntryScreen({Key? key}) : super(key: key);
  @override
  _AddHealthRecordEntryScreenState createState() =>
      _AddHealthRecordEntryScreenState();
}

class _AddHealthRecordEntryScreenState
    extends State<AddHealthRecordEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  List<TextEditingController> keyControllers =
      List.generate(0, (i) => TextEditingController());
  List<TextEditingController> valueControllers =
      List.generate(0, (i) => TextEditingController());
  final TextEditingController nameController = new TextEditingController();

  final TextEditingController dateController = new TextEditingController(
      text: "${DateTime.now().toLocal()}"
          .split(' ')[0]); //"${selectedDate.toLocal()}".split(' ')[0]
  final TextEditingController locationController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  final TextEditingController tagController = new TextEditingController();

  bool customField = false;
  int numberCustomField = 0;
  List<File> filePicked = [];
  List<String> filePickedName = [];

  Future<bool> pickFile() async {
    bool status = false;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      final fileTemporary = File(result!.files.single.path.toString());
      setState(() {
        filePicked.add(fileTemporary);
        filePickedName.add(result.files.single.name);
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
        filePicked.add(imageTemporary);
        filePickedName.add(image.name);
      });
      status = true;
    } catch (e) {
      print(e);
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
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

    DateTime selectedDate = DateTime.now();
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
      autofocus: false,
      controller: dateController,
      readOnly: true,
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
      onSaved: (value) {
        locationController.text = value!;
      },
    );

    final descriptionField = TextFormField(
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
      onSaved: (value) {
        descriptionController.text = value!;
      },
    );

    final tagField = TextFormField(
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
      onSaved: (value) {
        tagController.text = value!;
      },
    );

    Future<bool> uploadHealthRecord() async {
      try {
        DatabaseReference pushIDref =
            database.child("health-record").child(user.uid).push();
        String uniquePushID = pushIDref.key!;

        try {
          for (int i = 0; i < filePicked.length; i++) {
            Reference healthRecordref = FirebaseStorage.instance
                .ref()
                .child('health-record')
                .child(user.uid)
                .child(uniquePushID)
                .child('/' + filePickedName[i]);
            await healthRecordref.putData(await filePicked[i].readAsBytes());
          }
        } catch (e) {
          print(e);
          try {
            for (int i = 0; i < filePicked.length; i++) {
              Reference healthRecordref = FirebaseStorage.instance
                  .ref()
                  .child('health-record')
                  .child(user.uid)
                  .child(uniquePushID)
                  .child('/' + filePickedName[i]);
              await healthRecordref.putFile(File(filePicked[i].path));
            }
          } catch (e) {
            print(e);
            return false;
          }
        }

        try {
          await pushIDref.update({
            "creationdate": dateController.text,
            "description": descriptionController.text,
            "location": locationController.text,
            "name": nameController.text,
            "tag": tagController.text,
          });
          for (int i = 0; i < numberCustomField; i++) {
            await pushIDref
                .update({keyControllers[i].text: valueControllers[i].text});
          }
          for (int i = 0; i < filePicked.length; i++) {
            await pushIDref
                .update({"filename-$i": p.basename(filePickedName[i])});
          }
        } catch (e) {
          print(e);
          return false;
        }
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Rekam Medis Baru"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dateField,
                  nameField,
                  locationField,
                  descriptionField,
                  tagField,
                  Divider(
                    color: Colors.black54,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24, top: 10, bottom: 5),
                    child: Text(
                      'Lampiran',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kLightBlue1,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (filePicked.isNotEmpty)
                    for (File file in filePicked)
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              'Lampiran ${p.basename(file.path)} terpilih.',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          )),
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
                                    bool status =
                                        await pickImage(ImageSource.camera);
                                    if (status) {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Lampiran ditambahkan.",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        backgroundColor: kYellow,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      Navigator.of(alertContext).pop();
                                    } else {
                                      final snackBar = SnackBar(
                                        content: const Text("Dibatalkan.",
                                            style:
                                                TextStyle(color: Colors.black)),
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
                                    bool status =
                                        await pickImage(ImageSource.gallery);
                                    if (status) {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Lampiran ditambahkan.",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        backgroundColor: kYellow,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      Navigator.of(alertContext).pop();
                                    } else {
                                      final snackBar = SnackBar(
                                        content: const Text("Dibatalkan.",
                                            style:
                                                TextStyle(color: Colors.black)),
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
                                    bool status = await pickFile();
                                    if (status) {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Lampiran ditambahkan.",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        backgroundColor: kYellow,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      Navigator.of(alertContext).pop();
                                    } else {
                                      final snackBar = SnackBar(
                                        content: const Text("Dibatalkan.",
                                            style:
                                                TextStyle(color: Colors.black)),
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
                        const EdgeInsets.only(left: 24, top: 10, bottom: 5),
                    child: Text(
                      'Kolom Kustom',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kLightBlue1,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (customField)
                    for (int i = 0; i < numberCustomField; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                autofocus: false,
                                controller: keyControllers[i],
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
                                  labelText: "Key" + (i + 1).toString(),
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
                                maxLines: null,
                                autofocus: false,
                                controller: valueControllers[i],
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
                                  labelText: "Value" + (i + 1).toString(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  errorStyle: TextStyle(height: 0),
                                ),
                              ),
                            ),
                            IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: -4),
                                onPressed: () {
                                  setState(() {
                                    keyControllers.removeAt(i);
                                    valueControllers.removeAt(i);
                                    numberCustomField -= 1;
                                    if (numberCustomField == 0) {
                                      customField = false;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.black45,
                                  size: 16,
                                )),
                          ],
                        ),
                      ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        keyControllers.add(TextEditingController());
                        valueControllers.add(TextEditingController());
                        customField = true;
                        numberCustomField += 1;
                      });
                    },
                    child: Text(
                      "Tambahkan kolom kustom",
                      style: TextStyle(color: kWhite),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kLightBlue1)),
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  TapDebouncer(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final snackBar = SnackBar(
                          content: const Text("Sedang memuat...",
                              style: TextStyle(color: Colors.black)),
                          backgroundColor: kYellow,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        bool stateUpload = await uploadHealthRecord();
                        if (stateUpload) {
                          Navigator.of(context).pop();
                        } else {
                          final snackBar = SnackBar(
                            content: const Text(
                                "Upload gagal, cek koneksi internet.",
                                style: TextStyle(color: Colors.black)),
                            backgroundColor: kYellow,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    builder: (BuildContext context, TapDebouncerFunc? onTap) {
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
                                color: kWhite,
                                elevation: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.check_box_outlined,
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
                                    'Selesai dan Upload',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "Pastikan data yang dimasukkan telah benar. ",
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
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
