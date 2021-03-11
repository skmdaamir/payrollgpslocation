import 'dart:async';
import 'package:employeeapplication/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:employeeapplication/employee_login_page.dart';
import 'package:splashscreen/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme:
        ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    home: IntroScreen(),
  ));
}

class IntroScreen extends StatelessWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User result = FirebaseAuth.instance.currentUser;
    return SplashScreen(
        navigateAfterSeconds: result != null ? MainPage() : EmployeeLoginPage(),
        seconds: 3,
        backgroundColor: Colors.orangeAccent,
        title: Text(
          'Welcome to the Employee \n Application',
          textAlign: TextAlign.center,
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ));
  }
}
