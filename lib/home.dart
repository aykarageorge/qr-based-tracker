import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_register/add_customer.dart';
import 'package:customer_register/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'sign_in.dart';

class Home extends StatefulWidget {
  static String id = "home";
  final String message;

  Home({Key key, this.message}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(message);
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;

  List<CustomerData> customerLogs;
  String estb, username, uid, qrData = "";
  bool showSpinner = false;

  _HomeState(String message);

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    final FirebaseUser _user = await _auth.currentUser();
    _user.reload();
    setState(() {
      username = _user.email;
      uid = _user.uid;
    });
    getQRData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Customer Tracker"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, SignIn.id);
                    _auth.signOut();
                  },
                  child: Text("Sign Out", style: TextStyle(fontSize: 16)),
                )),
          ]),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  //Profile Card
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                        child: Container(
                            width: 150,
                            child: ButtonTheme(
                              minWidth: 150,
                              height: 200,
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, Profile.id);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person_pin,
                                      size: 60,
                                    ),
                                    Text(
                                        "\nProfile:\n" +
                                            (username != null ? username : ""),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                            ))),
                  ),
                  //QR Card
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                        child: Container(
                            width: 150,
                            child: FutureBuilder(
//                              future: getQR,
                              builder: (context, snapshot) {
                              return MaterialButton(
                                onPressed: () => toQrImageData(qrData),
                                child: Column(
                                  children: <Widget>[
                                    QrImage(
                                      data: qrData,
                                      version: QrVersions.auto,
//                                    size: 150,
                                      gapless: false,
                                    ),
                                    Text("Scan this QR or Tap on it to download.",
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                              );},
                            ))),
                  ),
                  // Enter Customer Card
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                        child: Container(
                            width: 150,
                            child: ButtonTheme(
                              minWidth: 150,
                              height: 200,
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AddCustomer.id);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person_add,
                                      size: 60,
                                    ),
                                    Text("\nAdd Customer / Enter Customer",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                            ))),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text('CUSTOMERS',
                  style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 5,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getListData(),
                  builder: (context, snapshot) {
                    if (customerLogs != null) {
                      if (customerLogs.length == 0) {
                        return Container(
                            alignment: Alignment.center,
                            child: Text("No Data",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold)));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: customerLogs.length,
                        itemBuilder: (ctx, int) {
                          return Card(
                              elevation: 2,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(customerLogs[int].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                      Row(children: <Widget>[
                                        // Column 1
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('📞: ' +
                                                    customerLogs[int].contact),
                                                Text("🌡️: " +
                                                    customerLogs[int]
                                                        .temperature),
                                              ]),
                                        ),
                                        //Column 2
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("📅: " +
                                                    customerLogs[int].date),
                                                Text("⏱: " +
                                                    customerLogs[int].inTime),
                                                Text(
                                                    "📝: " +
                                                        customerLogs[int]
                                                            .remarks,
                                                    textAlign:
                                                        TextAlign.justify),
                                              ]),
                                        )
                                      ]),
                                    ]),
                              ));
                        },
                      );
                    } else {
                      return Text("Nothing to show");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future getQRData() async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((value) => estb = value['establishment']);
    print("ESTB: " + estb);
      setState(() {
        qrData = Uri.encodeFull("https://aykara4.com/safer?val=" +
            json.encode({'establishment': estb, 'uid': uid}));
      });
      print("QR Data: " + qrData);
  }

  Future getListData() async {
    List<CustomerData> logs = new List();
    String name, contact, place, temperature, remarks;
    Timestamp time;
    await Firestore.instance
        .collection('users')
        .document(uid)
        .collection("customer_logs")
        .orderBy("time", descending: true)
        .limit(20)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((element) {
        name = element.data['customer'];
        contact = element.data['contact'];
        time = element.data['time'];
        place = element.data['place'];
        temperature = element.data['temperature'];
        remarks = element.data['remarks'];
        setState(() {
          logs.add(CustomerData(
              name: name,
              contact: contact,
              time: time.toDate().toString(),
              place: place,
              temperature: temperature,
              remarks: remarks));
        });
      });
    });

    customerLogs = logs;
    print("list length: " + customerLogs.length.toString());
  }

  void toQrImageData(String text) async {
    try {
      var status = await Permission.storage.request();
      print("Permission: " + status.isGranted.toString());
      if (status.isGranted) {
        final image = await QrPainter(
          data: text,
          version: QrVersions.auto,
          gapless: false,
          color: Colors.black,
          emptyColor: Colors.white,
        ).toImage(300);
        final a = await image.toByteData(format: ImageByteFormat.png);
        final File newImage = File('/storage/emulated/0/Download/QR-code.png');
        await newImage.writeAsBytes(a.buffer.asUint8List());
        _displayDialog(
            context, "QR code image saved to 'Download' folder in device.");
      }
    } catch (e) {
      print(e);
    }
  }

  _displayDialog(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Downloaded"),
            content: Text(msg),
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

class CustomerData {
  String name, contact, date, inTime, place, temperature, remarks;

  CustomerData(
      {String name,
      String contact,
      String time,
      String place,
      String temperature,
      String remarks}) {
    this.name = name;
    this.contact = contact;
    this.date = time.split(" ")[0];
    this.inTime = time.split(" ")[1].split(".")[0];
    this.place = place;
    this.temperature = temperature;
    this.remarks = remarks;
  }
}
