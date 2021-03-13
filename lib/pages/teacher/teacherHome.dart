import 'package:flutter/material.dart';

class TeachHome extends StatefulWidget {
  @override
  _TeachHomeState createState() => _TeachHomeState();
}

class _TeachHomeState extends State<TeachHome> {

  List<String> subjects = ['english', 'hindi', 'maths'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Teacher'),
        leading: Container(),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,),
              child: RaisedButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0,),
                  child: Text(subjects[index])
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
