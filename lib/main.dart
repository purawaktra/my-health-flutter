import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/welcome_screen.dart';
import 'package:flutter_auth/components/sign_method.dart';
import 'package:flutter_auth/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => SignProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'myHealth',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: WelcomeScreen(),
      ),
  );
}
