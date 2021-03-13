import 'package:flutter/material.dart';
import 'package:spook/pages/signin.dart';

class StartUp extends StatefulWidget {
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  @override
  Widget build(BuildContext context) {
    return SignIn();
  }
}
