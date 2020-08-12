import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_register/sign_in.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  static String id = "register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = Firestore.instance;

  String email;
  String password;
  String passwordConfirm;
  bool showSpinner = false;
  bool _isRegistrationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 8),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    email = value.toString().trim();
                  },
                ),
                Spacer(),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: 'Password'),
                  onChanged: (value) {
                    password = value.toString().trim();
                    if (password.compareTo(passwordConfirm) == 0)
                      _isRegistrationEnabled = true;
                    else
                      _isRegistrationEnabled = false;
                  },
                ),
                Spacer(),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: 'Confirm Password'),
                  onChanged: (value) {
                    passwordConfirm = value.toString().trim();
                    if (password.compareTo(passwordConfirm) == 0)
                      _isRegistrationEnabled = true;
                    else
                      _isRegistrationEnabled = false;
                  },
                ),
                Spacer(flex: 2),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    _register();
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Spacer(),
                FlatButton(
                  textColor: Colors.white,
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, SignIn.id);
                  },
                  child: Text(
                    "Already a user? Sign In",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                Spacer(flex: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _register() async {
    if (_isRegistrationEnabled) {
      setState(() {
        showSpinner = true;
      });
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await newUser.user.sendEmailVerification();
        if (newUser != null) {
          firestoreInstance
              .collection("users")
              .document((await _auth.currentUser()).uid)
              .setData({
            "email": (await _auth.currentUser()).email,
            "last_login": Timestamp.now(),
          });
        }
      } catch (e) {
        print(e);
        if (e.message != null) _displayDialog(context, e.message);
      } finally {
        setState(() {
          showSpinner = false;
        });
        _displayDialog(context, "An email has been sent for verification to the registered email. Please complete verification before logging in.\nThank You.");
      }
    } else {
      if (email == "" ||
          email == null ||
          password == "" ||
          password == null ||
          passwordConfirm == "" ||
          passwordConfirm == null)
        _displayDialog(context, "Enter all fields");
      else
        _displayDialog(context, "Passwords do not match!");
      return null;
    }
  }

  _displayDialog(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Registration Message !"),
            content: Text("" + msg, textAlign: TextAlign.justify),
            actions: <Widget>[
              new FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
