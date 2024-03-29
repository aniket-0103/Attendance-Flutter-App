import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var u_name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Image.asset('images/logo.png'),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: InputDecoration(
                labelText: 'E-mail',
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
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your password.',
                labelText: 'Password',
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
                  onPressed: () async {
                    try  {
                      final newuser = await _auth.signInWithEmailAndPassword(
                          email: email,
                          password: password
                      );
                      if (newuser != null) {
                        print("done");

                        // ignore: deprecated_member_use
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Logged in!!",
                            textAlign: TextAlign.center
                          ),
                          width: 280.0,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, // Inner padding for SnackBar content.
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ));

                        Navigator.pushNamed(context, '/home');
                      }

                      else{
                        // ignore: deprecated_member_use
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Incorrect Credentials"),
                        ));
                      }
                      // } on FirebaseAuthException catch (e) {
                    //   if (e.code == 'user-not-found') {
                    //     print('No user found for that email.');
                    //   } else if (e.code == 'wrong-password') {
                    //     print('Wrong password provided for that user.');
                    //   }
                    }
                    catch (e){
                      print(e);
                    }
                    //Implement login functionality.

                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}