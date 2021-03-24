import 'package:flutter/material.dart';
import 'package:spook/models/user.dart';
import 'package:spook/services/auth.dart';

class Settings extends StatefulWidget {

  final AppUser user;

  Settings({this.user});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Name: ' + widget.user.name),
              SizedBox(height: 10.0,),
              Text('Email: ' + widget.user.email),
              SizedBox(height: 10.0,),
              Text('Roll: ' + widget.user.roll),
              SizedBox(height: 10.0,),
              ElevatedButton(
                child: Text('Log out'),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
