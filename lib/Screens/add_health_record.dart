import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';
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
    final TextEditingController nameController = new TextEditingController();
    final nameField = TextFormField(
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
        hintText: "Nama",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Nama",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    DateTime selectedDate = DateTime.now();
    final TextEditingController dateController = new TextEditingController(
        text: "${selectedDate.toLocal()}"
            .split(' ')[0]); //"${selectedDate.toLocal()}".split(' ')[0]
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
      showCursor: true,
      readOnly: true,
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
        hintText: "Tanggal",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Tanggal",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController locationController =
        new TextEditingController();
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
        hintText: "Lokasi",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Lokasi",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController descriptionController =
        new TextEditingController();
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
        hintText: "Deskripsi",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Deskripsi",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController tagController = new TextEditingController();
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
        hintText: "Tag",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Tag",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    Future<bool> uploadHealthRecord() async {
      try {
        DatabaseReference pushIDref =
            database.child("health-record").child(user.uid).push();
        String uniquePushID = pushIDref.key!;
        Reference healthRecordref = FirebaseStorage.instance
            .ref()
            .child('health-record')
            .child(uniquePushID)
            .child('/' + uniquePushID);

        try {
          await healthRecordref.putData(await filePicked!.readAsBytes());
        } catch (e) {
          print(e);
          try {
            await healthRecordref.putFile(File(filePicked!.path));
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
            "filename": filename,
          });
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
                            bool status = await pickImage(ImageSource.camera);
                            if (status) {
                              final snackBar = SnackBar(
                                content: const Text("Photo terpilih.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
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
                              final snackBar = SnackBar(
                                content: const Text("Photo terpilih.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
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
                            final snackBar = SnackBar(
                              content: const Text("File terpilih.",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
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
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: kDarkBlue,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (filePicked != null)
                          if (p.extension(filename) == ".jpg" ||
                              p.extension(filename) == ".png")
                            Container(
                              child: Column(
                                children: [
                                  Image.file(
                                    filePicked!,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            )
                          else
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'File dengan nama $filename terpilih.',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ))
                        else
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Tidak ada file dan/atau gambar terpilih.',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),

                        // FutureBuilder<XFile?>(
                        //   future:
                        //       pickFile(), // a previously-obtained Future<String> or null
                        //   builder: (BuildContext context,
                        //       AsyncSnapshot<XFile?> snapshot) {
                        //     List<Widget> children;
                        //     if (snapshot.hasData) {
                        //       children = <Widget>[
                        //         Image.file(
                        //           File(snapshot.data!.path),
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ];
                        //     } else if (snapshot.hasError) {
                        //       children = <Widget>[
                        //         Padding(
                        //           padding: const EdgeInsets.only(top: 16),
                        //           child: Text('Error: ${snapshot.error}'),
                        //         )
                        //       ];
                        //     } else {
                        //       children = const <Widget>[Text('Tidak ada.')];
                        //     }
                        //     return Center(
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: children,
                        //       ),
                        //     );
                        //   },
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: kDarkBlue,
                        ),
                        dateField,
                        nameField,
                        locationField,
                        descriptionField,
                        tagField,
                        Divider(
                          color: kDarkBlue,
                        ),
                        InkWell(
                          onTap: () async {
                            final snackBar = SnackBar(
                              content: const Text("Sedang memuat...",
                                  style: TextStyle(color: Colors.black)),
                              backgroundColor: kYellow,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            bool stateUpload = await uploadHealthRecord();
                            if (stateUpload) {
                              final snackBar = SnackBar(
                                content: const Text("Upload berhasil.",
                                    style: TextStyle(color: Colors.black)),
                                backgroundColor: kYellow,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.of(context).pop();
                            } else {
                              final snackBar = SnackBar(
                                content: const Text(
                                    "Upload gagal, cek koneksi internet.",
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
                                  color: kWhite,
                                  elevation: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                        ),
                      ],
                    )))));
  }
}
