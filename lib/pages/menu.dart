import 'package:flutter/material.dart';
import 'package:spook/pages/settings.dart';
import 'package:spook/services/optionsBuilder.dart';

class Menu extends StatefulWidget {

  final index;

  Menu({this.index});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  List teachList = ['english', 'hindi', 'maths'];
  List studentList = ['english', 'hindi', 'maths'];

  @override
  Widget build(BuildContext context) {
    if(widget.index == 0)
      return ListBuild(list: teachList);
    if(widget.index == 1)
      return ListBuild(list: studentList,);
    return Settings();
  }
}
