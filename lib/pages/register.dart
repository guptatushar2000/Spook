import 'package:flutter/material.dart';
import 'package:spook/models/user.dart';
import 'package:spook/services/auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  AppUser user = AppUser();
  String _password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register to the app'),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  TextFormField(
                    validator: (val) {
                      return val.isEmpty? 'Provide a valid name': null;
                    },
                    onChanged: (val) {
                      setState(() {
                        user.name = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your Name',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    validator: (val) {
                      return val.isEmpty? 'Provide a valid roll number': null;
                    },
                    onChanged: (val) {
                      setState(() {
                        user.roll = val;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter your roll number',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    validator: (val) {
                      return (val.isEmpty || (!val.contains('@')))? 'Enter a valid email': null;
                    },
                    onChanged: (val) {
                      setState(() {
                        user.email = val;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter your email',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    validator: (val) {
                      return (val.isEmpty || val.length < 6)? 'Enter a valid password': null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _password = val;
                      });
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Enter your password',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  // DropdownButton<String>(
                  //   items: <String>['Teacher', 'Student']
                  //                   .map<DropdownMenuItem<String>>((String val) {
                  //                     return DropdownMenuItem<String>(
                  //                       value: val,
                  //                       child: Text(val),
                  //                     );
                  //   }).toList(),
                  //   onChanged: (value) {},
                  //   hint: Text('Select profession'),
                  // ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    child: Text('Register'),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        dynamic result = await _auth.registerWithEmailAndPassword(user.email, _password);
                        if(result == null) {
                          setState(() {
                            error = 'Please provide valid credentials';
                          });
                        } else {
                          // add data about the subs and classes on the database.
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20.0,),
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
