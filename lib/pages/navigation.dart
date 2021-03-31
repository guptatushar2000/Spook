import 'package:flutter/material.dart';
import 'package:spook/pages/register.dart';
import 'package:spook/pages/signin.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  bool pin = false;

  void togglePin() {
    setState(() {
      pin = !pin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return pin? Register(togglePin: togglePin): SignIn(togglePin: togglePin);
  }
}
