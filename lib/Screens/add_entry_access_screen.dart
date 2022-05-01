import 'package:flutter/material.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';

class EntryHealthRecord {
  final String accesstype;
  final String userid;
  final String enabled;
  final String date;
  final String hash;

  EntryHealthRecord(
      this.accesstype, this.userid, this.enabled, this.date, this.hash);
}

class AddEntryHealthRecordAccessScreen extends StatefulWidget {
  const AddEntryHealthRecordAccessScreen({Key? key}) : super(key: key);
  @override
  _AddEntryHealthRecordAccessScreenState createState() =>
      _AddEntryHealthRecordAccessScreenState();
}

class _AddEntryHealthRecordAccessScreenState
    extends State<AddEntryHealthRecordAccessScreen> {
  String dropdownValue = 'One';
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    final TextEditingController dateController = new TextEditingController(
        text: "${selectedDate.toLocal()}"
            .split(' ')[0]); //"${selectedDate.toLocal()}".split(' ')[0]

    final dateField = TextFormField(
      autofocus: false,
      controller: dateController,
      showCursor: true,
      readOnly: true,
      style: TextStyle(color: kBlack),
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

    final TextEditingController userIDController = new TextEditingController();
    final userIDField = TextFormField(
      maxLines: null,
      autofocus: false,
      controller: userIDController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.perm_identity_outlined,
          color: kBlack,
        ),
        hintText: "User ID",
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "User ID",
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
    return Background(
      title: "Entry Baru",
      description: Text("Deskripsi kosong."),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                dateField,
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_tree_outlined,
                      color: kBlack,
                    ),
                    hintText: "Belum diatur",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                    labelText: "Tipe Entry",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  autofocus: false,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Beri izin akses', 'Dapatkan izin akses']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                userIDField,
                descriptionField,
              ],
            ),
          ),
        ],
      )),
    );
  }
}
