import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/onboarding_screen.dart';
import 'package:myhealth/Screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../components/sign_method.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  get kYellow => null;

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
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        height: 64,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(urlImage),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Haii, " + name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Dashboard",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Expanded(
                        child: GridView.count(
                          padding: EdgeInsets.only(top: 4),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          primary: false,
                          children: <Widget>[
                            Card(
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen())),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/logo_app.png",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text("Data Pribadi")
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/logo_app.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Rekam Medis")
                                ],
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/logo_app.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Izin Akses")
                                ],
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/logo_app.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Sinkronisasi Data")
                                ],
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/logo_app.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Pengaturan")
                                ],
                              ),
                            ),
                            GestureDetector(
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
                                        style: TextStyle(color: Colors.black)),
                                    backgroundColor: Color(0xFFF8B501),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/images/logo_app.png",
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text("Logout")
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
