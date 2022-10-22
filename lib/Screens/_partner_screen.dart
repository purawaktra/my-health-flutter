import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/_partner_entry_screen.dart';
import 'package:myhealth/screens/add_partner_screen.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:myhealth/components/myhealthv11.g.dart';

class TestPartnerAccessScreen extends StatefulWidget {
  const TestPartnerAccessScreen({Key? key}) : super(key: key);
  @override
  _TestPartnerAccessScreenState createState() =>
      _TestPartnerAccessScreenState();
}

class _TestPartnerAccessScreenState extends State<TestPartnerAccessScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  String _counter = "kosong";

  final EthereumAddress contractAddr =
      EthereumAddress.fromHex('0x2b6a9b33AeD182D3432D90EADa8d36EAd6e93b44');
  var ethClient = Web3Client("http://34.72.180.127:8545", Client());

  Future<List<String>> getGrantedPermissionList() async {
    Myhealthv11 smart_contract =
        Myhealthv11(address: contractAddr, client: ethClient, chainId: 1337);
    return await smart_contract.GetGrantedPermissionList(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    var credentials =
        EthPrivateKey.fromHex(sha256.convert(utf8.encode(user.uid)).toString());
    Myhealthv11 smart_contract =
        Myhealthv11(address: contractAddr, client: ethClient, chainId: 1337);

    Future<List<String>> streamData = getGrantedPermissionList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightBlue1,
        title: Text("Partner"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh Halaman',
            onPressed: () {
              setState(() {
                streamData = getGrantedPermissionList();
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kLightBlue1,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => AddEntryHealthRecordAccessScreen()))
            .whenComplete(() => setState(() {
                  streamData = getGrantedPermissionList();
                })),
        tooltip: 'Partner baru',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<String>>(
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
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<String>? uids = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, top: 18),
                      child: Text(
                        'Connected',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kLightBlue1,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        for (String uid in uids!)
                          ExpansionTile(
                            title: FutureBuilder<DataSnapshot>(
                                future:
                                    database.child("fullname").child(uid).get(),
                                builder: (context2, snapshot2) {
                                  Widget child = Text("Memuat...",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ));
                                  if (snapshot2.hasData) if (snapshot2
                                      .data!.value
                                      .toString()
                                      .isNotEmpty) {
                                    child = Text(
                                      snapshot2.data!.value.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  } else {
                                    child = Text(
                                      "Nama partner belum diatur.",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }

                                  return child;
                                }),
                            subtitle: Text(
                              uid,
                              style: TextStyle(
                                color: Colors.black54,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TestPartnerEntryScreen(
                                                          partnerUid: uid,
                                                        )));
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
                                          onDoubleTap: () async {},
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
                                            "Buka dan hapus.",
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
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          EtherAmount balance =
                              await ethClient.getBalance(credentials.address);
                          setState(() {
                            _counter = balance.getInWei.toString();
                          });
                        },
                        child: const Text("Cek Balance")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          String result =
                              await smart_contract.AddBalanceToSender(
                                      credentials: credentials)
                                  .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print(intervalTime.toString());
                          });
                          setState(() {
                            _counter = result;
                          });
                        },
                        child: const Text("Add Balance")),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _counter = credentials.address.hex;
                          });
                        },
                        child: const Text("Cek Alamat")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          String result =
                              await smart_contract.GetPermissionNote(
                                      "akbar", "zidan")
                                  .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Note : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result;
                          });
                        },
                        child: const Text("Cek Note")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          bool result = await smart_contract.GetPermission(
                                  "akbar", "zidan")
                              .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Cek : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result.toString();
                          });
                        },
                        child: const Text("Cek Permission")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          String result = await smart_contract.AddPermission(
                                  "akbar", "zidan", "nyobain",
                                  credentials: credentials)
                              .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Add : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result;
                          });
                        },
                        child: const Text("Add Permission")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          String result = await smart_contract.DeletePermission(
                                  "akbar", "zidan",
                                  credentials: credentials)
                              .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Delete : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result;
                          });
                        },
                        child: const Text("Delete Permission")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          List<String> result =
                              await smart_contract.GetPendingPermissionList(
                                      "akbar")
                                  .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Pending : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result.toString();
                          });
                        },
                        child: const Text("Get Pending Permission")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          List<String> result =
                              await smart_contract.GetGrantedPermissionList(
                                      "akbar")
                                  .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Granted : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result.toString();
                          });
                        },
                        child: const Text("Get Granted Permission")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          List<String> result =
                              await smart_contract.GetIncomingPermissionList(
                                      "akbar")
                                  .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Incoming : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result.toString();
                          });
                        },
                        child: const Text("Get Incoming Permission")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          String result =
                              await smart_contract.ChangePermissionNote(
                                      "akbar", "zidan", "haii",
                                      credentials: credentials)
                                  .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Change : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result.toString();
                          });
                        },
                        child: const Text("Change Note")),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime start = DateTime.now();
                          int startTime = start.millisecondsSinceEpoch;
                          bool result = await smart_contract
                              .isExist("akbar")
                              .whenComplete(() {
                            DateTime finish = DateTime.now();
                            int finishTime = finish.millisecondsSinceEpoch;
                            int intervalTime = finishTime - startTime;
                            print("Change : " + intervalTime.toString());
                          });
                          setState(() {
                            _counter = result.toString();
                          });
                        },
                        child: const Text("isExist")),
                    Text(
                      _counter,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/partner_screen.png",
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Kamu belum menambahkan partner, kamu bisa berbagi rekam medis kamu dengan menambahkan partner lewat tombol tambah dibawah ya.",
                      style: const TextStyle(
                          color: kBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ));
            }
          }),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
