import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/search_result_health_record_entry.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class SearchHealthRecordEntryScreen extends StatefulWidget {
  const SearchHealthRecordEntryScreen({Key? key}) : super(key: key);
  @override
  _SearchHealthRecordEntryState createState() =>
      _SearchHealthRecordEntryState();
}

class _SearchHealthRecordEntryState
    extends State<SearchHealthRecordEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Pencarian berdasarkan kata kunci';
  final TextEditingController keySearchController = new TextEditingController();
  // final TextEditingController dateController = new TextEditingController(
  //     text: "${DateTime.now().toLocal()}"
  //         .split(' ')[0]); //"${selectedDate.toLocal()}".split(' ')[0]

  @override
  Widget build(BuildContext context) {
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
      keySearchController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }

    final dateField = TextFormField(
        autofocus: false,
        controller: keySearchController,
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
          keySearchController.text = value!;
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
            errorStyle: TextStyle(height: 0)));

    final keyPhraseField = TextFormField(
      autofocus: true,
      controller: keySearchController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: kBlack),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.keyboard_arrow_right,
          color: kBlack,
        ),
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
        labelText: "Kata Kunci",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ("");
        }
        return null;
      },
      onSaved: (value) {
        keySearchController.text = value!;
      },
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBlue1,
          title: Text("Pencarian"),
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
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.power_input,
                            color: kBlack,
                          ),
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                        autofocus: false,
                        value: dropdownValue,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          if (newValue == "Pencarian berdasarkan tanggal") {
                            keySearchController.text =
                                "${DateTime.now().toLocal()}".split(' ')[0];
                          }
                          if (newValue == "Pencarian berdasarkan kata kunci") {
                            keySearchController.text = "";
                          }
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>[
                          'Pencarian berdasarkan kata kunci',
                          'Pencarian berdasarkan tanggal'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      if (dropdownValue == 'Pencarian berdasarkan kata kunci')
                        keyPhraseField,
                      if (dropdownValue == 'Pencarian berdasarkan tanggal')
                        dateField,
                      Divider(
                        color: Colors.black54,
                      ),
                      TapDebouncer(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchResultHealthRecordEntryScreen(
                                          keyPhrase: keySearchController.text,
                                          searchType: dropdownValue,
                                        )));
                          }
                        },
                        builder:
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
                                    color: kWhite,
                                    elevation: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.search,
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
                                        'Cari',
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
                    ]),
              ),
            ),
          ),
        ));
  }
}
