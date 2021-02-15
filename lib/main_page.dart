import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference =
      FirebaseDatabase.instance.reference().child("Employee-Database");
  final _storage = FirebaseStorage.instance;

  getData() {
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values['email']);
        print(values['name']);
        print(values['imageUrl']);
      });
    });
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
                accountName: Text('Amir Shaikh'),
                accountEmail: Text('skmdaamir29@gmail.com'),
                currentAccountPicture: CircleAvatar(),
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
              ),
            ],
          ),
        ));
  }
}
