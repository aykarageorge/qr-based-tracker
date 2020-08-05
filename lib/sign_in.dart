import 'package:customer_register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  static String id = "sign_in";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  email = value.toString().trim();
                },
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  password = value.toString().trim();
                },
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) Navigator.pushNamed(context, Home.id);
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
                child: Text(
                  "Log In",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              FlatButton(
                color: Colors.deepOrange,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  Navigator.pushNamed(context, Register.id);
                  setState(() {
                    showSpinner = false;
                  });
                },
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
