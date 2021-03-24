import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spook/models/user.dart';
import 'package:spook/pages/settings.dart' as Set;
import 'package:spook/services/optionsBuilder.dart';

class Menu extends StatefulWidget {

  final index;

  Menu({this.index});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  List teachList;
  List studentList;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<DocumentSnapshot>(context);

    teachList = user != null? user.data()['teacher']: [];
    studentList = user != null? user.data()['student']: [];

    if(widget.index == 0)
      return ListBuild(list: teachList, index: widget.index,);
    if(widget.index == 1)
      return ListBuild(list: studentList, index: widget.index,);
    else
      return Set.Settings(user: AppUser(name: user.data()['name'], email: user.data()['email'], roll: user.data()['roll']));
  }
}
