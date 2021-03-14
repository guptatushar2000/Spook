import 'package:flutter/material.dart';
import 'package:spook/services/auth.dart';

class Settings extends StatefulWidget {
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
        child: RaisedButton(
          child: Text('Log out'),
          onPressed: () async {
            await _auth.signOut();
          },
        ),
      ),
    );
  }
}
