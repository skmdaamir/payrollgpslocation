import 'package:employeeapplication/employee_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:employeeapplication/bezier_container.dart';
import 'package:employeeapplication/main_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as Path;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  File _image;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User result = FirebaseAuth.instance.currentUser;
  final databaseReference =
      FirebaseDatabase.instance.reference().child("Employee-Database");
  final _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String photoUrl;

  TextEditingController displayName = new TextEditingController();
  TextEditingController contactno = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  getImageFile(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _image = image;
      _image = croppedFile;
    });
  }

  Future<void> sendData() async {
    var file = File(_image.path);

    if (_image != null) {
      //upload to firebase
      var snapshot = await _storage
          .ref()
          .child('profile-images/${Path.basename(_image.path)}')
          .putFile(file);
      print('File Uploaded Successfully');

      // ignore: await_only_futures
      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        photoUrl = downloadUrl;
        print(photoUrl);
      });
    } else {
      print('No Path Received');
    }

    databaseReference.push().set({
      "name": displayName.toString(),
      "contact-no": contactno.toString(),
      'email': email.toString(),
      'imageUrl': photoUrl.toString(),
    }).then((_) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Registeration Successfully')));
    }).catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(onError),
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    displayName.dispose();
    contactno.dispose();
    email.dispose();
    password.dispose();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'E',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xfffe46b10),
          ),
          children: [
            TextSpan(
              text: 'mpl',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'oyee',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _nameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: displayName,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: "Full Name",
              fillColor: Color(0xfff3f3f4),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return "Please Enter your Full Name";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _contactField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: contactno,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Contact No",
              fillColor: Color(0xfff3f3f4),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return "Please Enter your Contact Number";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _emailField(String s) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              fillColor: Color(0xfff3f3f4),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return "Please Enter your Email";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _passwordField({bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
              fillColor: Color(0xfff3f3f4),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return "Please Enter your Password";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: [
        _emailField('Email ID'),
        _passwordField(isPassword: true),
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _registerAccount();
            sendData();
          }
        },
        child: Text("Register",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        color: Colors.orangeAccent,
        height: 50,
        minWidth: 500,
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmployeeLoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.only(bottom: 70),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Click here',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xfff79c4f),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('Select your Profile Image'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    print(_image?.lengthSync());
    return Scaffold(
      body: Container(
        height: height,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned(
                    top: -MediaQuery.of(context).size.height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: BezierContainer(),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: height * .1),
                            _title(),
                            SizedBox(
                              height: 20,
                            ),
                            _nameField(),
                            SizedBox(
                              height: 1,
                            ),
                            _contactField(),
                            SizedBox(
                              height: 1,
                            ),
                            _emailPasswordWidget(),
                            SizedBox(
                              height: 20,
                            ),
                            _divider(),
                            Center(
                              child: _image == null
                                  ? Text('')
                                  : Image.file(
                                      _image,
                                      height: 200,
                                      width: 200,
                                    ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _submitButton(),
                            SizedBox(height: 20),
                            _loginAccountLabel(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 0,
                    child: _backButton(),
                  ),
                ],
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.orangeAccent,
            label: Text("Camera"),
            onPressed: () => getImageFile(ImageSource.camera),
            heroTag: UniqueKey(),
            icon: Icon(Icons.camera),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            backgroundColor: Colors.orangeAccent,
            label: Text("Gallery"),
            onPressed: () => getImageFile(ImageSource.gallery),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          )
        ],
      ),
    );
  }

  void _registerAccount() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text))
        .user;
    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    }
  }
}
