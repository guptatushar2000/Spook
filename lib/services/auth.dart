import 'package:firebase_auth/firebase_auth.dart';
import 'package:spook/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create app user from firebase user.
  AppUser _userFromFirebaseUser(User user) {
    return user != null? AppUser(uid: user.uid, name: user.displayName, email: user.email, roll: '12345678', encode: [0, 0, 0, 0]): null;
  }

  // auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges()
                  .map(_userFromFirebaseUser);
  }

  // sign in with email and password.
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password.
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out.
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in anon.
  Future signInAnon() async {
    try {
      UserCredential result =  await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}