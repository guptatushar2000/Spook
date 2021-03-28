import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spook/models/user.dart';
import 'package:spook/services/auth.dart';
import 'package:spook/services/cameraSupport.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  AppUser user = AppUser(encode: [0, 0, 0, 0]);
  String _password = '';
  String error = '';
  bool imageReceived = false;

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
                  // Input name of the user.
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
                  // Input roll number of the user.
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
                  // Input email id of the user.
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
                  // Input password of the user.
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
                  // Input image of the user.
                  ElevatedButton(
                    child: !imageReceived? Text('Provide user Image'): Icon(Icons.thumb_up_alt_sharp),
                    onPressed: () async {
                      dynamic encoding = await CameraSupport(context: context).getImageClickedFromCamera();
                      encoding != null? setState(() {
                        imageReceived = true;
                        user.encode = encoding;
                      }): print('no image was found');
                    },
                  ),
                  SizedBox(height: 40.0,),
                  // Register the user on click.
                  ElevatedButton(
                    child: Text('Register'),
                    onPressed: !imageReceived? null: () async {
                      if(_formKey.currentState.validate()) {
                        dynamic result = await _auth.registerWithEmailAndPassword(user, _password);
                        if(result == null) {
                          setState(() {
                            error = 'Please provide valid credentials';
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20.0,),
                  // Display error message.
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
