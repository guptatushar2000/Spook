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
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,),
              child: RaisedButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0,),
                  child: Column(
                    children: <Widget>[
                      Text('Name: ' + widget.list[index]['subject']),
                      SizedBox(height: 5.0,),
                      Text('Code: ' + widget.list[index]['key'])
                    ],
                  ),
                ),
                onPressed: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}
