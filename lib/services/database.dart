import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spook/models/user.dart';
import 'package:intl/intl.dart';

class DatabaseService {

  final String uid;
  final String code;

  DatabaseService({this.uid, this.code});

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
    await subjectCollection.doc(code).set({
      'isActive': isActive,
      'subject': name,
      'code': code,
      'teacher': teacher,
    });
    // creating a collection of documents within subject document to hold attendance data.
    return await subjectCollection.doc(code).collection('attend').doc(teacher).set({
      'total': 0,
      'dates': <DateTime>[],
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
        // include the student in the attendance collection inside the subject document.
        await subjectCollection.doc(code).collection('attend').doc(uid).set({
          'total': 0,
          'dates': <DateTime>[],
        });
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

  // update isActive key in subject document for starting attendance.
  Future startClass(String code, bool value) async {
    try {
      return await subjectCollection.doc(code).update({'isActive': value});
    } catch(e) {

    }
  }

  // fetch complete face encoding list from firestore.
  Future getFaceEncodingFromFirestore() async {
    try {
      List encoding = [];
      await userCollection.doc(uid).get().then((DocumentSnapshot snapshot) {
        List.from(snapshot.data()['encode']).forEach((element) {
          encoding.add(element);
        });
      });
      return encoding;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // mark presence in attendance collection.
  Future markPresence() async {
    try {
      String currDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await subjectCollection.doc(code).collection('attend').doc(uid).update({'dates': FieldValue.arrayUnion([currDate])});
      int length = await subjectCollection.doc(code).collection('attend').doc(uid).get().then((DocumentSnapshot snapshot) {
        return snapshot.data()['dates'].length;
      });
      await subjectCollection.doc(code).collection('attend').doc(uid).update({'total': length});
      return null;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // get user stream.
  Stream<DocumentSnapshot> get user {
    return userCollection.doc(uid).snapshots();
  }

  // get subject stream.
  Stream<DocumentSnapshot> get sub {
    return subjectCollection.doc(code).snapshots();
  }
}