import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_register/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Profile extends StatefulWidget {

  static String id = "profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool showSpinner = false;
  String name;
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = Firestore.instance;
  final TextEditingController _nameController  = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void updateValues() async {
    firestoreInstance
        .collection("users")
        .document((await _auth.currentUser()).uid)
        .updateData({
      "establishment": name
    });
  }

  void loadValues() async {
    final FirebaseUser _user = await _auth.currentUser();
    firestoreInstance.collection("users").document(_user.uid).get().then((value) {
       name = value.data["establishment"];
      _nameController.text = value.data["establishment"];
    });
  }

  @override
  Widget build(BuildContext context) {
    loadValues();
    return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: SafeArea(
            top: false,
            bottom: false,
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Form(
                  autovalidate: true,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.work),
                          labelText: 'Establishment Name',
                        ),
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 40.0, top: 20.0),
                          child: RaisedButton(
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                await updateValues();
                              } catch (e) {
                                print(e);
                              } finally {
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.pushReplacementNamed(context, Home.id, arguments: "Updated");
                              }
                            },
                            child: Text('Save Details'),
                          )),
                    ],
                  )),
            )));
  }

}
