import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spook/models/user.dart';
import 'package:spook/services/cameraSupport.dart';
import 'package:spook/services/database.dart';

class ListBuild extends StatefulWidget {

  final List list;
  final int index;

  ListBuild({this.list, this.index});

  @override
  _ListBuildState createState() => _ListBuildState();
}

class _ListBuildState extends State<ListBuild> {

  String name;
  String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            name = widget.list[index]['subject'];
            code = widget.list[index]['key'];
            return StreamProvider<DocumentSnapshot>.value(
              value: DatabaseService(code: code).sub,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0,),
                child: Card(
                  elevation: 10.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Name: ' + name),
                            SizedBox(height: 5.0,),
                            Text('Code: ' + code),
                          ],
                        ),
                        Attendance(index: widget.index),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Attendance extends StatefulWidget {

  final index;

  Attendance({this.index});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return widget.index == 0?
            // declare widget for the teacher to start attendance
            TeacherAttendance():
            // declare widget for the student to mark presence
            StudentAttendance()
    ;
  }
}

class TeacherAttendance extends StatefulWidget {
  @override
  _TeacherAttendanceState createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {

  bool _isActive = false;
  String code;

  // ask the user if he wishes to continue;
  Future<bool> prompt(bool value) async {
    bool newValue = false;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(
          child: Center(child: Text('Do you wish to continue?'),),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.pop(context);
              newValue = !value;
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
              newValue = value;
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return newValue;
  }

  @override
  Widget build(BuildContext context) {
    final subject = Provider.of<DocumentSnapshot>(context);
    final user = Provider.of<AppUser>(context);
    code = subject != null? subject.data()['code']: '';
    _isActive = subject != null? subject.data()['isActive']: false;
    return Switch.adaptive(
      value: _isActive,
      onChanged: (val) async {
        bool value = await prompt(_isActive);
        setState(() {
          _isActive = value;
        });
        await DatabaseService(code: code).startClass(code, _isActive);
        _isActive? await DatabaseService(uid: user.uid, code: code).markPresence(): print('Class deactivated!');
      },
    );
  }
}

class StudentAttendance extends StatefulWidget {
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {

  double euclideanDistance(dynamic encoding, dynamic curFace) {
    try {
      double distance = 0.0;
      for(int i=0; i<192; ++i) {
        distance += (encoding[i]-curFace[i])*(encoding[i]-curFace[i]);
      }
      distance = sqrt(distance);
      print('distance between face vectors is: ' + distance.toString());
      return distance;
    } catch(e) {
      print(e.toString());
      return 100.0;
    }
  }

  Future _markPresence(String uid, String code) async {
    dynamic output = await CameraSupport(context: context).getImageClickedFromCamera();
    dynamic encoding = await DatabaseService(uid: uid).getFaceEncodingFromFirestore();
    dynamic result;
    if(output == null || encoding == null || encoding == []) {
      result = false;
    } else  {
      // boundary distance has been kept 1.0 unit for trial purposes.
      if(euclideanDistance(encoding, output) <= 1.0) {
        result = true;
        await DatabaseService(uid: uid, code: code).markPresence();
      } else {
        result = false;
      }
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: result == true? Text('You have been marked present!'): Text('Unknown person detected.'),
        );
      }
    );
    await Future.delayed(Duration(milliseconds: 1500,));
    Navigator.pop(context);
  }

  Future prompt(String uid, String code) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(
          child: Center(child: Text('Do you wish to continue?'),),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              Navigator.pop(context);
              await _markPresence(uid, code);
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final subject = Provider.of<DocumentSnapshot>(context);
    final user = Provider.of<AppUser>(context);
    return ElevatedButton(
      child: Text('Mark Presence'),
      onPressed: (subject != null ? subject.data()['isActive']: false) ? () async => await prompt(user.uid, subject.data()['code']): null,
    );
  }
}