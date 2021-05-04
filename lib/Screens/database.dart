import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Database extends StatefulWidget {
  @override
  _DatabaseState createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  static String full_name;
  var lecture;
  var uid;
  var age;
  var time;
  var url= "http://127.0.2.2:5000/";
  PickedFile _imageFile;
  User loggedInUser;
  final picker = ImagePicker();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<bool> uploadImage(url) async {
    var filepath;
    try {
      final pickedImage = await picker.getImage(source: ImageSource.camera);
      if(pickedImage != null)
        filepath = pickedImage.path;

      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      print("Image picker error " + e);
    }

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    print(res);
    return false;
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if(user != null)
        loggedInUser = user;
    }
    catch(e){
      print(e);
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close),
              onPressed: (){
            _auth.signOut();
            Navigator.pop(context);
              }),
        ],
        title: Text("Add a student"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  //Do something with the user input.
                  full_name = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'Full Name',
                  labelStyle: TextStyle(
                      color: Colors.black45
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style:  TextStyle(color: Colors.black) ,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  //Do something with the user input.
                  lecture = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your password.',
                  labelText: 'Lecture name',
                  labelStyle: TextStyle(
                      color: Colors.black45
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style:  TextStyle(color: Colors.black) ,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  uid = value;
                },
                decoration: InputDecoration(
                  labelText: 'User ID',
                  labelStyle: TextStyle(
                      color: Colors.black45
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: (){
                      var recognition_result = uploadImage(url);
                      print(recognition_result);
                      if(recognition_result != false)
                      {
                        time = new DateTime.now();
                        final user = _firestore.collection(full_name).add({
                          'Date': time,
                          'Lecture': lecture
                        });}
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Attendance recorded"),
                      ));
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Record Attendance',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10.0,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 16.0),
              //   child: Material(
              //     elevation: 5.0,
              //     color: Colors.lightBlueAccent,
              //     borderRadius: BorderRadius.circular(30.0),
              //     child: MaterialButton(
              //       onPressed: () {
              //         //Go to login screen.
              //         Navigator.pushNamed(context, '/face_recognition');
              //         // time = new DateTime.now();
              //       },
              //       minWidth: 200.0,
              //       height: 42.0,
              //       child: Text(
              //         'Capture face',
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}