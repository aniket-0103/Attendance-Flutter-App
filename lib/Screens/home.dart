import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
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
  var uploadurl= 'http://127.0.2.2:5000/';
  var downloadurl = 'http://127.0.2.2:5000/hello';
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

  Future uploadImage(url) async {
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
  }
  void getresult(url) async {
    var response = await http.get(url);
    var decodedData = convert.jsonDecode(response.body);
    uid = decodedData['Name'];
    print(uid );

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
        title: Text("Record Attendance"),
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
              // TextField(
              //   style: TextStyle(color: Colors.black),
              //   keyboardType: TextInputType.text,
              //   onChanged: (value) {
              //     //Do something with the user input.
              //     full_name = value;
              //   },
              //   decoration: InputDecoration(
              //     hintText: 'Enter your email',
              //     labelText: 'Full Name',
              //     labelStyle: TextStyle(
              //         color: Colors.black45
              //     ),
              //     contentPadding:
              //     EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide:
              //       BorderSide(color: Colors.lightBlueAccent, width: 1.0),
              //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide:
              //       BorderSide(color: Colors.lightBlueAccent, width: 2.0),
              //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 8.0,
              // ),
              TextField(
                style:  TextStyle(color: Colors.black) ,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  //Do something with the user input.
                  lecture = value;
                },
                decoration: InputDecoration(
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
              // TextField(
              //   style:  TextStyle(color: Colors.black) ,
              //   keyboardType: TextInputType.text,
              //   onChanged: (value) {
              //     uid = value;
              //   },
              //   decoration: InputDecoration(
              //     labelText: 'User ID',
              //     labelStyle: TextStyle(
              //         color: Colors.black45
              //     ),
              //     contentPadding:
              //     EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide:
              //       BorderSide(color: Colors.lightBlueAccent, width: 1.0),
              //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide:
              //       BorderSide(color: Colors.lightBlueAccent, width: 2.0),
              //       borderRadius: BorderRadius.all(Radius.circular(32.0)),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 24.0,
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      await uploadImage(uploadurl) ;
                      await getresult(downloadurl);

                    time = new DateTime.now();
                    final user = _firestore.collection(uid).add({
                      'Date': time,
                      'Lecture': lecture
                    });
                    // ignore: deprecated_member_use

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Attendance recorded',
                        textAlign: TextAlign.center),
                        backgroundColor: Colors.green,
                        width: 280.0, // Width of the SnackBar.
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, // Inner padding for SnackBar content.
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    );
                     print("done");
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: ()  {
                      Navigator.pushNamed(context, '/students_list');
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'View students',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}