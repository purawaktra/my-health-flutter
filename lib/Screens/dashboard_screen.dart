import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/account_information_screen.dart';
import 'package:myhealth/Screens/health_record_access_screen.dart';
import 'package:myhealth/Screens/health_record_screen.dart';
import 'package:myhealth/Screens/onboarding_screen.dart';
import 'package:myhealth/Screens/profile_screen.dart';
import 'package:myhealth/Screens/setting_screen.dart';
import 'package:myhealth/Screens/shared_health_record.dart';
import 'package:myhealth/constants.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/sign_method.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();

    if (statuses[Permission.location] == PermissionStatus.granted) {
      if (statuses[Permission.storage] == PermissionStatus.granted) {
        setState(() {
          print(statuses);
          _permissionStatus = PermissionStatus.granted;
          print(_permissionStatus);
        });
      }
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final name = user.displayName!;
    final email = user.email!;
    final urlImage = user.photoURL!;
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DoubleBack(
          onFirstBackPress: (context) {
            final snackBar = SnackBar(
              content: Text('Tekan kembali untuk keluar.',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Color(0xFFF8B501),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Stack(
            children: <Widget>[
              Scaffold(
                backgroundColor: Colors.white,
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/background_2.png",
                  width: size.width,
                  opacity: AlwaysStoppedAnimation<double>(1),
                ),
              ),
              Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 36,
                      ),
                      Container(
                        height: 48,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(urlImage),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Haii, " + name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                          height: 120,
                          width: size.width,
                          child: Card(
                            elevation: 4,
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HealthRecordScreen())),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/dashboard_0.png",
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "Rekam \nMedisku",
                                    style: TextStyle(
                                      fontSize: 24,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 24,
                      ),
                      Expanded(
                        child: GridView.count(
                          padding: EdgeInsets.only(top: 4),
                          childAspectRatio: 0.8,
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          primary: false,
                          children: <Widget>[
                            Card(
                              color: kLightBlue2,
                              elevation: 4,
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen())),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/dashboard_1.png",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Informasi \nPribadi",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              color: kLightBlue2,
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AccountInformationScreen())),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/dashboard_2.png",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Informasi \nAkun",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: kLightBlue2,
                              elevation: 4,
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HealthRecordAccessScreen())),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/dashboard_3.png",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Bagikan\nRekam Medis",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: kLightBlue2,
                              elevation: 4,
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SharedHealthRecordScreen())),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/dashboard_4.png",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Dibagikan\nKepada Saya",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 4,
                              color: kLightBlue2,
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => SettingScreen())),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/dashboard_5.png",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Informasi dan\nPengaturan",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: kLightBlue2,
                              elevation: 4,
                              child: InkWell(
                                onTap: () async {
                                  final snackBar = SnackBar(
                                    content: const Text("Sedang memuat...",
                                        style: TextStyle(color: Colors.black)),
                                    backgroundColor: Color(0xFFF8B501),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  final provider = Provider.of<SignProvider>(
                                      context,
                                      listen: false);
                                  String logoutstate = await provider.logout();
                                  if (logoutstate == "true") {
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OnboardingScreen()));
                                    }
                                  } else if (logoutstate == "false") {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Gagal untuk logout, silahkan coba kembali.",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: Color(0xFFF8B501),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/dashboard_6.png",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Informasi \nPribadi",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
              )
            ],
          ),
        ));
  }
}
