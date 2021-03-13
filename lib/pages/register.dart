import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register to the app'),
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your Name',
                ),
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter your roll number',
                ),
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter your email',
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
              DropdownButton<String>(
                items: <String>['Teacher', 'Student']
                                .map<DropdownMenuItem<String>>((String val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                }).toList(),
                onChanged: (value) {},
                hint: Text('Select profession'),
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                child: Text('Register'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
