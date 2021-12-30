import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/black_screen.dart';
import 'package:flutter_auth/Screens/home_screen.dart';
import 'package:flutter_auth/Screens/profile_screen.dart';
import 'package:flutter_auth/components/sign_method.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final name = user.displayName!;
    final email = user.email!;
    final urlImage = user.photoURL!;
    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  name: name,
                  urlImage: urlImage,
                ),
              )),
            ),
            Container(
              padding: padding,
              child: Column(
                children: <Widget>[
                  buildMenuItem(
                    text: "Halaman Utama",
                    icon: Icons.home_rounded,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: "Rekam Medis",
                    icon: Icons.health_and_safety_outlined,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: "Izin Akses",
                    icon: Icons.workspaces_outline,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: "Sinkronisasi Data",
                    icon: Icons.update,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Divider(color: Colors.white70),
                  const SizedBox(
                    height: 24,
                  ),
                  buildMenuItem(
                    text: "Pengaturan",
                    icon: Icons.settings,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    text: "Keluar",
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
          onTap: onClicked,
          child: Container(
            padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(urlImage),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: 180,
                      child: Text(
                        email,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ));

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
        break;

      case 1:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BlankScreen()));
        break;

      case 2:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BlankScreen()));
        break;

      case 3:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BlankScreen()));
        break;

      case 4:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BlankScreen()));
        break;

      case 5:
        final provider = Provider.of<SignProvider>(context, listen: false);
        provider.logout();
    }
  }
}
