import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:customer_register/register.dart';
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
  final firestoreInstance = Firestore.instance;

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
                    if (!newUser.user.isEmailVerified) {
                      _displayDialog(context,
                          "Please verify yourself before logging in. Check you mailbox with registered email to continue.");
                    return;
                    }
                    if (newUser != null) {
                      var firebaseUser =
                          await FirebaseAuth.instance.currentUser();
                      firestoreInstance
                          .collection("users")
                          .document(firebaseUser.uid)
                          .updateData({"last_login": Timestamp.now()});
                      Navigator.pushReplacementNamed(context, Home.id);
                    }
                  } catch (e) {
                    print(e.message);
                    if (e.message != null) _displayDialog(context, e.message);
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
                textColor: Colors.white,
                onPressed: () async {
                  await _passwordReset(context);
                },
                child: Text(
                  "Forgot Password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Text(
                "\n\n\nNew User?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Login Message !"),
            content: Text("" + msg, textAlign: TextAlign.justify),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _passwordReset(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Password Reset"),
                FlatButton(
                  child: Text("X",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onPressed: () => Navigator.of(context).pop(),
                  textColor: Colors.black,
                  color: Colors.orangeAccent,
                  shape: new CircleBorder(),
                )
              ],
            ),
            content:
                Text("Enter your registered email below to reset password:"),
            actions: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                width: 500,
                margin: EdgeInsets.only(bottom: 30),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    setState(() {
                      email = value.toString().trim();
                    });
                  },
                ),
              ),
              FlatButton(
                child: Text(
                  'Send email to reset',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    await _auth.sendPasswordResetEmail(email: email);
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    await _displayDialog(context, "Invalid email");
                    return;
                  }
                  setState(() {
                    showSpinner = false;
                  });
                  await _displayDialog(context,
                      "An email has been sent to the registered email-id. Please check the email and reset your password before logging in again.");
                  Navigator.of(context).pop();
                },
                textColor: Colors.black,
                color: Colors.orangeAccent,
              ),
            ],
          );
        });
  }
}
