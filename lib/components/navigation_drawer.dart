import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/blank_screen.dart';
import 'package:myhealth/Screens/dashboard_screen.dart';
import 'package:myhealth/Screens/profile_screen.dart';
import 'package:myhealth/components/sign_method.dart';
import 'package:myhealth/constants.dart';
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    urlImage,
                    width: 90,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/profile-bg3.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home_rounded,
                color: kLightBlue1,
              ),
              title: Text("Halaman Utama"),
              onTap: () => selectedItem(context, 0),
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: kLightBlue1),
              title: Text("Profil"),
              onTap: () => selectedItem(context, 1),
            ),
            ListTile(
              leading:
                  Icon(Icons.health_and_safety_outlined, color: kLightBlue1),
              title: Text("Rekam Medis"),
              onTap: () => selectedItem(context, 2),
            ),
            ListTile(
              leading: Icon(Icons.workspaces_outline, color: kLightBlue1),
              title: Text("Izin Akses"),
              onTap: () => selectedItem(context, 3),
            ),
            ListTile(
              leading: Icon(Icons.update, color: kLightBlue1),
              title: Text("Sinkronisasi Data"),
              onTap: () => selectedItem(context, 4),
            ),
            Divider(color: kLightBlue1),
            ListTile(
              leading: Icon(Icons.settings, color: kLightBlue1),
              title: Text("Pengaturan"),
              onTap: () => selectedItem(context, 5),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: kLightBlue1),
              title: Text("Keluar"),
              onTap: () => selectedItem(context, 6),
            ),
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
    final color = Colors.black;
    final hoverColor = Colors.black87;

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
            MaterialPageRoute(builder: (context) => DashboardScreen()));
        break;

      case 1:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfileScreen()));
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
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BlankScreen()));
        break;

      case 6:
        final provider = Provider.of<SignProvider>(context, listen: false);
        provider.logout();
    }
  }
}
