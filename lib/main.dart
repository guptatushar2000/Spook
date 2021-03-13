import 'package:flutter/material.dart';
import 'package:spook/pages/register.dart';
import 'package:spook/pages/signin.dart';
import 'package:spook/pages/startup.dart';
import 'package:spook/pages/teacher/teacherHome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TeachHome(),
      },
    );
  }
}

