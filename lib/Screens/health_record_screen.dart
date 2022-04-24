import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/add_health_record.dart';
import 'package:myhealth/components/background.dart';
import 'package:myhealth/constants.dart';

class HealthRecordScreen extends StatefulWidget {
  const HealthRecordScreen({Key? key}) : super(key: key);
  @override
  _HealthRecordScreenState createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  String aa = "aa";

  Future<Iterable<DataSnapshot>> getdata() async {
    DataSnapshot healthRecordRef = await database
        .child("health-record")
        .child(user.uid)
        .limitToFirst(2)
        .get();
    Iterable<DataSnapshot> a = healthRecordRef.children;
    // for (DataSnapshot imageSnapshot in a) {
    //   print(imageSnapshot.key.toString());
    // }
    return a;
  }

  bool _customTileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Background(
        title: "Rekam Medisku",
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddHealthRecordScreen())),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: kBlack,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rekam Medis Baru',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "Rekam medis dapat berupa gambar, foto, atau dokumen.",
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
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Divider(
              color: kDarkBlue,
            ),
          ),
          FutureBuilder<Iterable<DataSnapshot>>(
              future: getdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  Iterable<DataSnapshot>? healthRecordData = snapshot.data!;
                  return Column(
                    children: [
                      for (DataSnapshot imageSnapshot in healthRecordData)
                        ExpansionTile(
                          title: Text(
                            imageSnapshot.key!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            'Trailing expansion arrow icon',
                            style: TextStyle(
                              color: Colors.black54,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          children: <Widget>[
                            ListTile(title: Text('This is tile number 1')),
                          ],
                        )
                    ],
                  );
                  // return Flexible(
                  //     child: ListView.builder(
                  //         scrollDirection: Axis.vertical,
                  //         itemCount: 15,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           return ExpansionTile(
                  //             title: Text(
                  //               "gg",
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 18,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //             subtitle: Text(
                  //               'Trailing expansion arrow icon',
                  //               style: TextStyle(
                  //                 color: Colors.black54,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //             children: <Widget>[
                  //               ListTile(title: Text('This is tile number 1')),
                  //             ],
                  //           );
                  //         }));
                }
              })
        ]));
  }
}
