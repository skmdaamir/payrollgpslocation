import 'package:employeeapplication/Constants.dart';
import 'package:employeeapplication/employee_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = _auth.currentUser;
    setState(() {});
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
                accountName: Text('${user?.displayName}'),
                accountEmail: Text('${user?.email}'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage('${user?.photoURL}'),
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
                onTap: () async {
                  await _auth.signOut();
                  Constants.prefs.setBool("loggedin", false);
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
