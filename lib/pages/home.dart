import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spook/models/user.dart';
import 'package:spook/pages/menu.dart';
import 'package:spook/services/database.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  String subject = '';
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String error = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getClassCode(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    return StreamProvider<DocumentSnapshot>.value(
      value: DatabaseService(uid: user.uid).user,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome user'),
        ),
        body: Menu(index: _selectedIndex,),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.looks_one),
              label: 'Host a class',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.looks_two),
              label: 'Join a class',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
        floatingActionButton: _selectedIndex == 2? null: FloatingActionButton(
          child: const Icon(Icons.add_rounded),
          onPressed: () {
            return showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        _selectedIndex == 0? Text('Enter class name'): Text('Enter the class code'),
                        SizedBox(height: 5.0,),
                        TextFormField(
                          onChanged: (val) {
                            setState(() {
                              subject = val;
                            });
                          },
                        ),
                        SizedBox(height: 3.0,),
                        Text(error),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(onPressed: () async {
                    String code = getClassCode(6);
                    if(_selectedIndex == 0) {
                      await DatabaseService(uid: user.uid).updateSubjectData(code, subject, user.uid, false);
                      await DatabaseService(uid: user.uid).updateSubject('teacher', 'add', code);
                    } else {
                      dynamic result = await DatabaseService(uid: user.uid).checkSubject(subject);
                      if(result == true) {
                        await DatabaseService(uid: user.uid).updateSubject('student', 'add', subject);
                      } else {
                        setState(() {
                          error = 'Invalid code';
                        });
                        print('subject not found');
                      }
                    }
                    Navigator.pop(context);
                  }, child: Text('Submit')),
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                ],
              ),
              barrierDismissible: true,
              barrierColor: Colors.transparent,
            );
          },
        ),
      ),
    );
  }
}
