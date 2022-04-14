import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final name = user.displayName!;
    final email = user.email!;
    final urlImage = user.photoURL!;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: DoubleBack(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24,
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
                              name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              email,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen())),
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/logo_app.png",
                                  width: 100,
                                  height: 100,
                                ),
                                Text("Data Pribadi")
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logo_app.png",
                                width: 100,
                                height: 100,
                              ),
                              Text("Rekam Medis")
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logo_app.png",
                                width: 100,
                                height: 100,
                              ),
                              Text("Izin Akses")
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logo_app.png",
                                width: 100,
                                height: 100,
                              ),
                              Text("Sinkronisasi Data")
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logo_app.png",
                                width: 100,
                                height: 100,
                              ),
                              Text("Pengaturan")
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logo_app.png",
                                width: 100,
                                height: 100,
                              ),
                              Text("Logout")
                            ],
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
