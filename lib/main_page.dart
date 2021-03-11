import 'dart:convert';

import 'package:employeeapplication/employee_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:employeeapplication/user_model.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  // String _currentName;
  // String _currentEmail;
  // String _currentUserPhoto;
  final String url =
      "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCaN8IM8LbgtFZo_Wspcw0tnFWlurnBIzI";

  List data;

  // Future<String> _getCurrentUserName() async {
  //   User user = await FirebaseAuth.instance.currentUser;
  //   return user.displayName;
  // }

  @override
  void initState() {
    super.initState();
    initUser();
    getData();
    // doAsyncStuff();
    // _states();
    TabController controller = new TabController(length: 5, vsync: this);
    final User user = FirebaseAuth.instance.currentUser;
    print(user.displayName);
    print(user.email);
  }

  initUser() async {
    user = _auth.currentUser;
  }

  // doAsyncStuff() async {
  //   var name = await _getCurrentUserName();
  // }

  // _states() async {
  //   var user = FirebaseAuth.instance.currentUser;
  //   var name = user.displayName;
  //   var email = user.email;
  //   var photoUrl = user.photoURL;

  //   setState(() {
  //     this._currentName = name;
  //     this._currentEmail = email;
  //     this._currentUserPhoto = photoUrl;
  //     print(_currentName);
  //     print(_currentEmail);
  //     print(_currentUserPhoto);
  //   });
  // }

  Future<String> getData() async {
    var response = await http.get(
      // Encode the url
      Uri.encodeFull(url),
      // only accept json response
      headers: {"Accept": "application/json"},
    );
    print(response.body);

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson['Employee-Database'];
      print('Accessing Database');
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
          backgroundColor: Colors.orangeAccent,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('${user.displayName}'),
                accountEmail: Text('${user.email}'),
                // currentAccountPicture: CircleAvatar(
                //   backgroundImage: NetworkImage('${user.photoURL}'),
                // ),
                decoration: BoxDecoration(color: Colors.orangeAccent),
              ),
              ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.account_circle_rounded),
              ),
              ListTile(
                title: Text('Tasks & Clients'),
                leading: Icon(Icons.insert_chart_outlined_sharp),
              ),
              ListTile(
                title: Text('Salary/Payroll'),
                leading: Icon(Icons.money),
              ),
              ListTile(
                title: Text('Attendance'),
                leading: Icon(Icons.calendar_today),
              ),
              ListTile(
                title: Text('Leaves'),
                leading: Icon(Icons.edit),
              ),
              ListTile(
                title: Text('Orders'),
                leading: Icon(Icons.note_add),
              ),
              ListTile(
                title: Text('Log out'),
                leading: Icon(Icons.logout),
                onTap: () async {
                  await _auth.signOut();
                  // Constants.prefs.setBool("loggedin", false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmployeeLoginPage()));
                },
              ),
            ],
          ),
        ));
  }
}
