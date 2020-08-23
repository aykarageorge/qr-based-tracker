import 'package:customer_register/profile.dart';

import 'add_customer.dart';
import 'home.dart';
import 'register.dart';
import 'sign_in.dart';
import 'welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Tracker',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: Welcome.id,
      routes: {
        Welcome.id: (context) => Welcome(),
        Register.id: (context) => Register(),
        SignIn.id: (context) => SignIn(),
        Home.id: (context) => Home(),
        AddCustomer.id: (context) => AddCustomer(),
        Profile.id: (context) => Profile(),
      },
    );
  }
}