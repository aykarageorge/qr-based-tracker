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
      title: 'Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Welcome.id,
      routes: {
        Welcome.id: (context) => Welcome(),
        Register.id: (context) => Register(),
        SignIn.id: (context) => SignIn(),
        Home.id: (context) => Home()
      },
    );
  }
}