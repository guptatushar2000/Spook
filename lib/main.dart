import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spook/models/user.dart';
import 'package:spook/pages/startup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spook/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => StartUp(),
        },
      ),
    );
  }
}

