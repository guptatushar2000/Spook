import 'package:flutter/material.dart';
import 'package:spook/pages/register.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();

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
                  decoration: InputDecoration(
                    hintText: 'Enter the email',
                  ),
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  child: Text('Enter the app'),
                  onPressed: () {},
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  child: Text('Register new user'),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Register())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
