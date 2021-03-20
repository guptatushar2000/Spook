import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spook/models/user.dart';

class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  // collection reference.
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference subjectCollection = FirebaseFirestore.instance.collection('subject');

  // update the user's data.
  Future updateUserData(AppUser user, List teacherSubjects, List studentSubjects) async {
    return await userCollection.doc(uid).set({
      'teacher': teacherSubjects,
      'student': studentSubjects,
      'name': user.name,
      'roll': user.roll,
      'email': user.email,
      'encode': user.encode,
    });
  }

  // update subject data.
  Future updateSubjectData(String code, String name, String teacher, bool isActive) async {
    return await subjectCollection.doc(code).set({
      'isActive': isActive,
      'subject': name,
      'code': code,
      'teacher': teacher,
    });
  }

  // update subjects in person's list
  Future updateSubject(String type, String action, String code) async {
    try {

      String subjectName = await subjectCollection.doc(code).get().then((DocumentSnapshot snapshot) {
        return snapshot.data()['subject'];
      });

      Map sub = {'key': code, 'subject': subjectName};

      if(action == 'add') {
        await userCollection.doc(uid).update({type: FieldValue.arrayUnion([sub])});
      }
      if(action == 'remove') {
        await userCollection.doc(uid).update({type: FieldValue.arrayRemove([sub])});
      }
    } catch(e) {
      print('error is: ' + e.toString());
      return null;
    }
  }

  // check if a subject exists.
  Future checkSubject(String code) async {
    try {
      return await subjectCollection.doc(code).get().then((DocumentSnapshot snapshot) {
        if(snapshot.exists) {
          return true;
        } else {
          print('no document found');
          return false;
        }
      });
    } catch(e) {
      print('error: ' + e.toString());
      return false;
    }
  }

  // get user stream.
  Stream<DocumentSnapshot> get user {
    return userCollection.doc(uid).snapshots();
  }

}