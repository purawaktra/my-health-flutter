import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/Screens/profile_screen.dart';
import 'package:flutter_auth/constants.dart';

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
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    name: name,
                    urlImage: urlImage,
                  ),
              )),
            ),
            Container(
              padding: padding,
              child: Column(
                children: [buildMenuItem(
                  text: "People",
                  icon: Icons.people,
                ),
                  const SizedBox(height: 16,),
                  buildMenuItem(
                    text: "Favourites",
                    icon: Icons.favorite_border,
                  ),
                  const SizedBox(height: 16,),
                  buildMenuItem(
                    text: "Workflow",
                    icon: Icons.workspaces_outline,
                  ),
                  const SizedBox(height: 16,),
                  buildMenuItem(
                    text: "Updates",
                    icon: Icons.update,
                  ),
                  const SizedBox(height: 24,),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24,),
                  buildMenuItem(
                    text: "Settings",
                    icon: Icons.settings,
                  ),
                  const SizedBox(height: 16,),
                  buildMenuItem(
                    text: "Log Out",
                    icon: Icons.logout,
                  ),
                  const SizedBox(height: 16,),],
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
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage),),
              SizedBox(width: 20,),
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
                  const SizedBox(height: 4,),
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
        )
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: () {},
    );
  }

  // void selectedItem(BuildContext context, int index) {
  //   switch (index) {
  //     case 0:
  //       break
  //   }
  // }
}