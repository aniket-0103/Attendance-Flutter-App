import 'package:attendance_app/Screens/home.dart';
import 'package:attendance_app/Screens/face_detector.dart';
import 'package:attendance_app/Screens/students_list.dart';
import 'package:attendance_app/Screens/login.dart';
import 'package:attendance_app/Screens/register.dart';
import 'package:attendance_app/Screens/students_list.dart';
import 'package:attendance_app/Screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/face_recognition.dart';

void main()  async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(AttendanceApp());
  }

class AttendanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => Database(),
        '/face_detector': (context) => MyApp(),
        '/face_recognition': (context) => Tensorflow(),
        '/students_list': (context) => StudentsList()

      },
    );
  }
}