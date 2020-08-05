import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'sign_in.dart';

class Home extends StatefulWidget {

  static String id = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Tracker"),
      ),
      body: Column(
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
                              onPressed: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.person_pin,
                                    size: 60,
                                  ),
                                  Text("\nProfile:\n",
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
                          child: Column(children: <Widget>[
                            CachedNetworkImage(
                                imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png'
                            ),
                            Text("Scan this QR")
                          ],))),
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
                              onPressed: () {},
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (ctx, int) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text('User Name $int'),
                    trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      Text('IN  Time: 12:00 PM '),
                      Text('OUT Time: 01:00 PM'),
                    ],),
                    subtitle: Text('Date: 22/07/2020'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
