import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/health_record_entry_screen.dart';

class SearchResultHealthRecordEntryScreen extends StatefulWidget {
  final String searchType;
  final String keyPhrase;
  const SearchResultHealthRecordEntryScreen(
      {Key? key, required this.searchType, required this.keyPhrase})
      : super(key: key);
  @override
  _SearchResultHealthRecordEntryState createState() =>
      _SearchResultHealthRecordEntryState();
}

class _SearchResultHealthRecordEntryState
    extends State<SearchResultHealthRecordEntryScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance.ref();
  Future<Iterable<DataSnapshot>> getdata() async {
    DataSnapshot healthRecordRef =
        await database.child("health-record").child(user.uid).get();
    Iterable<DataSnapshot> a = healthRecordRef.children;
    return a;
  }

  @override
  Widget build(BuildContext context) {
    Future<Iterable<DataSnapshot>> streamData = getdata();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBlue1,
          title: Text("Hasil Pencarian"),
        ),
        body: FutureBuilder<Iterable<DataSnapshot>>(
            future: streamData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Text(
                  "Menunggu Server...",
                  style: TextStyle(
                    color: Colors.black54,
                    overflow: TextOverflow.ellipsis,
                  ),
                ));
              } else if (snapshot.data!.isEmpty) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "Kayanya kamu belum bikin rekam medis sama sekali :)",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ));
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text(
                  "Memuat...",
                  style: TextStyle(
                    color: Colors.black54,
                    overflow: TextOverflow.ellipsis,
                  ),
                ));
              } else {
                Iterable<DataSnapshot>? healthRecordData = snapshot.data!;
                final Map<String, Map<String, String>> healthRecordMap = {};
                for (DataSnapshot a in healthRecordData) {
                  Map<String, String> temp = {};
                  for (DataSnapshot b in a.children) {
                    temp[b.key.toString()] = b.value.toString();
                  }
                  healthRecordMap[a.key.toString()] = temp;
                }
                // print(healthRecordMap);
                List healthRecordList = healthRecordMap.entries.toList();
                List healthRecordSearchedList = [];
                healthRecordList.sort((a, b) => b.value["creationdate"]
                    .toString()
                    .compareTo(a.value["creationdate"].toString()));

                if (this.widget.searchType == "Pencarian berdasarkan tanggal") {
                  for (MapEntry<String, Map<String, String>> healthRecordEntry
                      in healthRecordList) {
                    for (MapEntry<String, String> healthRecordItemEntry
                        in healthRecordEntry.value.entries) {
                      if (healthRecordItemEntry.key == "creationdate") {
                        if (healthRecordItemEntry.value ==
                            this.widget.keyPhrase) {
                          healthRecordSearchedList.add(healthRecordEntry);
                          break;
                        }
                      }
                    }
                  }
                }
                if (this.widget.searchType ==
                    "Pencarian berdasarkan kata kunci") {
                  RegExp regExp = new RegExp(
                    "(${this.widget.keyPhrase})",
                    caseSensitive: false,
                    multiLine: false,
                  );
                  RegExp regExp2 = new RegExp(
                    "(filename)",
                    caseSensitive: false,
                    multiLine: false,
                  );
                  for (MapEntry<String, Map<String, String>> healthRecordEntry
                      in healthRecordList) {
                    for (MapEntry<String, String> healthRecordItemEntry
                        in healthRecordEntry.value.entries) {
                      if (healthRecordItemEntry.key == "creationdate") continue;
                      if (regExp2.hasMatch(healthRecordItemEntry.key)) continue;
                      if (regExp.hasMatch(healthRecordItemEntry.value)) {
                        healthRecordSearchedList.add(healthRecordEntry);
                        break;
                      }
                    }
                  }
                }

                return Container(
                  child: ListView(
                    children: [
                      for (MapEntry<String,
                              Map<String, String>> healthRecordEntry
                          in healthRecordSearchedList)
                        ExpansionTile(
                          title: Builder(builder: (BuildContext context) {
                            Widget child =
                                Text(healthRecordEntry.value["name"].toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ));
                            return child;
                          }),
                          subtitle: Row(
                            children: [
                              Text(
                                healthRecordEntry.key,
                                style: TextStyle(
                                  color: Colors.black54,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              for (MapEntry<String,
                                      String> healthRecordItemEntry
                                  in healthRecordEntry.value.entries)
                                if (healthRecordItemEntry.key.toString() ==
                                    "creationdate")
                                  Text(
                                    healthRecordItemEntry.value.toString(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                            ],
                          ),
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Card(
                                      color: kLightBlue2,
                                      elevation: 4,
                                      child: InkWell(
                                        onTap: () async {
                                          Navigator.of(context)
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HealthRecordEntryScreen(
                                                            healthRecordKey:
                                                                healthRecordEntry
                                                                    .key,
                                                          )))
                                              .whenComplete(() {
                                            setState(() {
                                              streamData = getdata();
                                            });
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.open_in_new,
                                              color: kBlack,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Card(
                                      color: kRed,
                                      elevation: 4,
                                      child: InkWell(
                                        onTap: () {
                                          final snackBar = SnackBar(
                                            content: const Text(
                                                "Double klik untuk menghapus.",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            backgroundColor: kYellow,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        },
                                        onDoubleTap: () async {
                                          try {
                                            try {
                                              for (MapEntry<String,
                                                      String> itemSnapshot
                                                  in healthRecordEntry
                                                      .value.entries) {
                                                if (itemSnapshot.value
                                                    .toString()
                                                    .startsWith("filename")) {
                                                  await storage
                                                      .child('health-record')
                                                      .child(user.uid)
                                                      .child(itemSnapshot.value
                                                          .toString())
                                                      .delete();
                                                }
                                              }
                                            } catch (e) {
                                              print(e);
                                            }

                                            await database
                                                .child("health-record")
                                                .child(user.uid)
                                                .child(healthRecordEntry.key)
                                                .remove();
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  "Hapus berhasil.",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              backgroundColor: kYellow,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            setState(() {
                                              streamData = getdata();
                                            });
                                          } catch (e) {
                                            print(e.toString());
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  "Hapus gagal, cek koneksi anda.",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              backgroundColor: kYellow,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.delete,
                                              color: kWhite,
                                            )
                                          ],
                                        ),
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
                                          "Buka, berbagi, dan hapus.",
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
                            SizedBox(
                              height: 10,
                            ),
                            for (MapEntry<String, String> itemSnapshot
                                in healthRecordEntry.value.entries)
                              if (itemSnapshot.key.toString() != "name")
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child:
                                      Builder(builder: (BuildContext context) {
                                    Icon icons = Icon(
                                      Icons.settings,
                                      color: kBlack,
                                    );
                                    int? maxLines = 1;
                                    String title = "Not defined";
                                    if (itemSnapshot.key.toString() ==
                                        "location") {
                                      icons = Icon(
                                        Icons.location_on_outlined,
                                        color: kBlack,
                                      );
                                      title = "Lokasi";
                                      return TextFormField(
                                        autofocus: false,
                                        readOnly: true,
                                        maxLines: maxLines,
                                        controller: TextEditingController(
                                            text:
                                                itemSnapshot.value.toString()),
                                        style: TextStyle(color: kBlack),
                                        decoration: InputDecoration(
                                          prefixIcon: icons,
                                          hintText: title,
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none,
                                          labelText: title,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                        ),
                                      );
                                    } else if (itemSnapshot.key.toString() ==
                                        "description") {
                                      icons = Icon(
                                        Icons.list_alt_outlined,
                                        color: kBlack,
                                      );
                                      title = "Deskripsi";
                                      maxLines = null;
                                      return TextFormField(
                                        autofocus: false,
                                        readOnly: true,
                                        maxLines: maxLines,
                                        controller: TextEditingController(
                                            text:
                                                itemSnapshot.value.toString()),
                                        style: TextStyle(color: kBlack),
                                        decoration: InputDecoration(
                                          prefixIcon: icons,
                                          hintText: title,
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none,
                                          labelText: title,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                        ),
                                      );
                                    } else if (itemSnapshot.key.toString() ==
                                        "tag") {
                                      icons = Icon(
                                        Icons.tag,
                                        color: kBlack,
                                      );
                                      title = "Tag";
                                      return TextFormField(
                                        autofocus: false,
                                        readOnly: true,
                                        maxLines: maxLines,
                                        controller: TextEditingController(
                                            text:
                                                itemSnapshot.value.toString()),
                                        style: TextStyle(color: kBlack),
                                        decoration: InputDecoration(
                                          prefixIcon: icons,
                                          hintText: title,
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none,
                                          labelText: title,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                        ),
                                      );
                                    }
                                    return Container();
                                  }),
                                ),
                          ],
                        ),
                    ],
                  ),
                );
              }
            }));
  }
}
