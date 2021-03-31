import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spook/models/user.dart';
import 'package:spook/pages/home.dart';
import 'package:spook/pages/navigation.dart';

class StartUp extends StatefulWidget {
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    return user!=null? Home(): Navigation();
  }
}
