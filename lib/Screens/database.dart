import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database extends StatefulWidget {
  @override
  _DatabaseState createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  String full_name;
  var contact_no;
  var age;
  var time;
  User loggedInUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
              // SizedBox(
              //   height: 8.0,
              // ),
              // TextField(
              //   style:  TextStyle(color: Colors.black) ,
              //   keyboardType: TextInputType.phone,
              //   onChanged: (value) {
              //     //Do something with the user input.
              //     contact_no = value;
              //   },
              //   decoration: InputDecoration(
              //     hintText: 'Enter your password.',
              //     labelText: 'Contact No.',
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
              // TextField(
              //   style:  TextStyle(color: Colors.black) ,
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) {
              //     age = value;
              //   },
              //   decoration: InputDecoration(
              //     hintText: 'Enter your password.',
              //     labelText: 'Age',
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
                      time = new DateTime.now();
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Add',
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