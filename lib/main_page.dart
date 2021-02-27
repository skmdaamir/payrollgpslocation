import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:employeeapplication/employee_login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:employeeapplication/user_model.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  final String url =
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCaN8IM8LbgtFZo_Wspcw0tnFWlurnBIzI';

  List data;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
    initUser();
  }

  initUser() async {
    user = _auth.currentUser;
    setState(() {});
  }

  Future<String> getJsonData() async {
    var response = await http.get(
        // Encode the url
        Uri.encodeFull(url),
        headers: {'Accept': 'application/json'});

    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['Employee-Database'];
    });

    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
          backgroundColor: Colors.orangeAccent,
        ),
        body: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {}),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("${user.displayName}"),
                accountEmail: Text('${user.email}'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("${user.photoURL}"),
                ),
                decoration: BoxDecoration(color: Colors.orangeAccent),
              ),
              ListTile(
                title: Text('Profile'),
                trailing: Icon(Icons.account_circle_rounded),
              ),
              ListTile(
                title: Text('Tasks & Clients'),
                trailing: Icon(Icons.insert_chart_outlined_sharp),
              ),
              ListTile(
                title: Text('Salary/Payroll'),
                trailing: Icon(Icons.money),
              ),
              ListTile(
                title: Text('Attendance'),
                trailing: Icon(Icons.calendar_today),
              ),
              ListTile(
                title: Text('Leaves'),
                trailing: Icon(Icons.edit),
              ),
              ListTile(
                title: Text('Orders'),
                trailing: Icon(Icons.note_add),
              ),
              ListTile(
                  title: Text('Log out'),
                  trailing: Icon(Icons.logout),
                  onTap: () {
                    _auth.signOut().then((res) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeLoginPage()),
                          (Route<dynamic> route) => false);
                    });
                  }),
            ],
          ),
        ));
  }
}
