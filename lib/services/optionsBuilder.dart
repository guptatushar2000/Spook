import 'package:flutter/material.dart';

class ListBuild extends StatefulWidget {

  final List list;
  final int index;

  ListBuild({this.list, this.index});

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
              child: Card(
                elevation: 10.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text('Name: ' + widget.list[index]['subject']),
                          SizedBox(height: 5.0,),
                          Text('Code: ' + widget.list[index]['key']),
                        ],
                      ),
                      Attendance(index: widget.index,),
                    ],
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

  // fetch isActive value from the subject database.
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: _isActive,
      onChanged: (val) {
        setState(() {
          _isActive = !_isActive;
        });
      },
    );
  }
}

class StudentAttendance extends StatefulWidget {
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {

  void _markPresence() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('You have been marked present!'),
        );
      }
    );
    await Future.delayed(Duration(milliseconds: 1500,));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Mark Presence'),
      onPressed: _markPresence,
    );
  }
}



