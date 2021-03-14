import 'package:flutter/material.dart';

class ListBuild extends StatefulWidget {

  final List list;

  ListBuild({this.list});

  @override
  _ListBuildState createState() => _ListBuildState();
}

class _ListBuildState extends State<ListBuild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return RaisedButton(
              child: Text(widget.list[index]),
              onPressed: () {},
            );
          },
        ),
      ),
    );
  }
}
