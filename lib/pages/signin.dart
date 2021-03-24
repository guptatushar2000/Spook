import 'package:flutter/material.dart';
import 'package:spook/models/user.dart';
import 'package:spook/pages/register.dart';
import 'package:spook/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  AppUser user = AppUser();
  String _password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-in to the app'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty || !val.contains('@')? 'Enter valid email': null;
                  },
                  onChanged: (val) {
                    setState(() {
                      user.email = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter the email',
                  ),
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty || val.length < 6? 'Enter valid password': null;
                  },
                  onChanged: (val) {
                    _password = val;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('Sign-in anon'),
                  onPressed: () async {
                    dynamic result = await _auth.signInAnon();
                    if(result == null) {
                      print('Error signing in');
                    } else {
                      print('user signed in:');
                      print(result);
                    }
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('Enter the app'),
                  onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(user.email, _password);
                      if(result == null)  {
                        setState(() {
                          error = 'Incorrect credentials';
                        });
                      } else {
                        // fetch subs and classes from database for displaying.
                      }
                    }
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('Register new user'),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Register())),
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
    );
  }
}
