import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/account_screen.dart';
import 'package:myhealth/screens/partner_screen.dart';
import 'package:myhealth/screens/health_record_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HealthRecordScreen(),
    EntryAccessScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description_outlined,
            ),
            label: 'Rekam Medis',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_alt_outlined,
            ),
            label: 'Partner',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kLightBlue1,
        unselectedItemColor: Colors.black87,
        onTap: _onItemTapped,
      ),
    );
  }
}
