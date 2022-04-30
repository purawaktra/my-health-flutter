import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/dashboard_screen.dart';
import 'package:myhealth/constants.dart';
import 'package:myhealth/screens/account_screen.dart';
import 'package:myhealth/screens/add_entry_access.dart';
import 'package:myhealth/screens/add_health_record.dart';
import 'package:myhealth/screens/health_record_access_screen.dart';
import 'package:myhealth/screens/health_record_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.ref();

  int _selectedIndex = 3;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    HealthRecordScreen(),
    HealthRecordAccessScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _onItemFloatingButton() {
    Widget child;
    if (_selectedIndex == 1) {
      child = FloatingActionButton(
        backgroundColor: kLightBlue1,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => AddHealthRecordScreen()))
            .whenComplete(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget))),
        tooltip: 'Rekam Medis Baru',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      );
    } else if (_selectedIndex == 2) {
      child = FloatingActionButton(
        backgroundColor: kLightBlue1,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => AddEntryHealthRecordAccessScreen()))
            .whenComplete(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget))),
        tooltip: 'Rekam Medis Baru',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      );
    } else {
      child = Container();
    }
    return child;
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
              Icons.home,
            ),
            label: 'Feed',
          ),
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
      floatingActionButton: _onItemFloatingButton(),
    );
  }
}
