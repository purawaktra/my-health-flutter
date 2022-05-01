import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';

class EditHealthRecordScreen extends StatefulWidget {
  final DataSnapshot healthRecord;
  const EditHealthRecordScreen({Key? key, required this.healthRecord})
      : super(key: key);

  @override
  _EditHealthRecordScreenState createState() => _EditHealthRecordScreenState();
}

class _EditHealthRecordScreenState extends State<EditHealthRecordScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  String displayTextID = "Belum diatur";
  String displayTextCreationDate = "Belum diatur";
  String displayTextDescription = "Belum diatur";
  String displayTextFilename = "Belum diatur";
  String displayTextLocation = "Belum diatur";
  String displayTextName = "Belum diatur";
  String displayTextTag = "Belum diatur";

  @override
  Widget build(BuildContext context) {
    setState(() {
      displayTextID = widget.healthRecord.key.toString();
    });
    for (DataSnapshot itemSnapshot in widget.healthRecord.children) {
      if (itemSnapshot.key == "creationdate") {
        setState(() {
          displayTextCreationDate = itemSnapshot.value.toString();
        });
      } else if (itemSnapshot.key == "description") {
        setState(() {
          displayTextDescription = itemSnapshot.value.toString();
        });
      } else if (itemSnapshot.key == "filename") {
        setState(() {
          displayTextFilename = itemSnapshot.value.toString();
        });
      } else if (itemSnapshot.key == "location") {
        setState(() {
          displayTextLocation = itemSnapshot.value.toString();
        });
      } else if (itemSnapshot.key == "name") {
        setState(() {
          displayTextName = itemSnapshot.value.toString();
        });
      } else if (itemSnapshot.key == "tag") {
        setState(() {
          displayTextTag = itemSnapshot.value.toString();
        });
      }
    }
    final TextEditingController idController =
        new TextEditingController(text: displayTextID);
    final idField = TextFormField(
      autofocus: false,
      readOnly: true,
      controller: idController,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.description_outlined,
          color: kBlack,
        ),
        hintText: "ID Rekam Medis - Tetap",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "ID Rekam Medis - Tetap",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    final TextEditingController nameController =
        new TextEditingController(text: displayTextName);
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
        new TextEditingController(text: displayTextLocation);
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
        new TextEditingController(text: displayTextDescription);
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

    final TextEditingController tagController =
        new TextEditingController(text: displayTextTag);
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

    return Background(
      title: "Edit Rekam Medis",
      description: Text("Deskripsi kosong."),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                idField,
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
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    try {
                      DatabaseReference pushIDref = database
                          .child("health-record")
                          .child(user.uid)
                          .child(displayTextID);
                      await pushIDref.update({
                        "creationdate": dateController.text,
                        "description": descriptionController.text,
                        "location": locationController.text,
                        "name": nameController.text,
                        "tag": tagController.text,
                      }).whenComplete(() {
                        final snackBar = SnackBar(
                          content: const Text("Edit berhasil.",
                              style: TextStyle(color: Colors.black)),
                          backgroundColor: kYellow,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      });
                    } catch (e) {
                      print(e);
                      final snackBar = SnackBar(
                        content: const Text("Edit gagal, cek koneksi internet.",
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: kYellow,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                              'Selesai',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "Pastikan data yang diubah telah benar. ",
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
        ),
      ),
    );
  }
}
