import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:customer_register/home.dart';
import 'package:flutter/material.dart';

class AddCustomer extends StatefulWidget {
  static String id = "add_customer";

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {

  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final firestoreInstance = Firestore.instance;

  void logCustomer(String customer, String contact, String place, String temperature, String remarks) async {
    firestoreInstance
        .collection("users")
        .document((await _auth.currentUser()).uid)
        .collection("customer_logs")
        .add({
      "time": Timestamp.now(),
      "customer": customer,
      "contact": contact,
      "place" : place,
      "temperature" : temperature,
      "remarks" : remarks
    });
  }

  @override
  Widget build(BuildContext context) {

    final _customerName = TextEditingController();
    final _customerPhone = TextEditingController();
    final _customerPlace = TextEditingController();
    final _customerTemperature = TextEditingController();
    final _customerRemarks = TextEditingController();

    return Scaffold(
        appBar: AppBar(title: Text("Add a Customer")),
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
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter your first and last name',
                          labelText: 'Name *',
                        ),
                        keyboardType: TextInputType.text,
                        controller: _customerName,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: 'Enter a phone number',
                          labelText: 'Phone *',
                        ),
                        keyboardType: TextInputType.phone,
                        controller: _customerPhone,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.home),
                          hintText: 'Customer is coming from ...',
                          labelText: 'Coming From',
                        ),
                        keyboardType: TextInputType.text,
                        controller: _customerPlace,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.local_hospital),
                          hintText: 'Temprature Check',
                          labelText: 'Temperature',
                        ),
                        keyboardType: TextInputType.number,
                        controller: _customerTemperature,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.subject),
                          hintText: 'No. of people or other remarks',
                          labelText: 'Remarks',
                        ),
                        keyboardType: TextInputType.phone,
                        controller: _customerRemarks,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 40.0, top: 20.0),
                          child: RaisedButton(
                            onPressed: () async {
                              if(_customerName.text.length < 3 || _customerPhone.text.length < 5) {
                                _displayDialog(context, "Input correct name and phone number.");
                                return;
                              }
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                logCustomer(_customerName.text, _customerPhone.text, _customerPlace.text, _customerTemperature.text, _customerRemarks.text);
                              } catch (e) {
                                print(e);
                              } finally {
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.pushReplacementNamed(context, Home.id, arguments: "Customer Added");
                              }
                            },
                            child: Text('Submit'),
                          )),
                    ],
                  )),
            )));
  }

  _displayDialog(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Input Error"),
            content: Text("" + msg),
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
