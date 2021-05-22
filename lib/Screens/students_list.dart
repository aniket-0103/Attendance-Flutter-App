import 'package:flutter/material.dart';
import 'package:attendance_app/Screens/home.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentsList extends StatefulWidget {

  @override
  _StudentsListState createState() => _StudentsListState();
}
class _StudentsListState extends State<StudentsList> {

  String name ;
  List<String> lecture = [];
  String loggedInUser;
  List time = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  var users = FirebaseFirestore.instance;

  @override

  void initState(){
    super.initState();
    getUser();
    print("done");
    getAttendanceData();

  }
  void getAttendanceData(){

    FirebaseFirestore.instance
        .collection(loggedInUser)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        lecture.add(doc["Lecture"]);
        Timestamp t = doc['Date'];
        DateTime d = t.toDate();
        time.add(d.toString());
        print(doc["Lecture"]);
      });
    });
    print('done');
    print(lecture);
  }
  void getUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != null) {
        loggedInUser = user.email;
        print(user.email);
      }
    }
    catch(e){
      print(e);
    }

    FirebaseFirestore.instance
        .collection('Users')
        .where('E-mail', isEqualTo: loggedInUser)
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            loggedInUser = doc["Name"];
            print(loggedInUser);
          });
    });

  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Aniket '),),
        ),
        body: Container(
          height:1700,
          child:ListView.builder(
            itemCount: lecture.length,
            itemBuilder: (_, index) {
              return Card(
                color: Colors.blue[100],
                child: ListTile(
                  title: Text(lecture[index]),
                  subtitle: Text(time[index]),
                  leading: Icon(Icons.arrow_forward),
                  trailing: Icon(Icons.access_time)
            ),
              );}
          ),
        ),
      ),
    );
  }
}

