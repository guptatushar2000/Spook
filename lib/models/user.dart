class StudentUser {

  List subjects;
  StudentUser({this.subjects});
}

class TeacherUser {

  List subjects;
  TeacherUser({this.subjects});
}

class AppUser {

  final uid;
  String name = 'Guest';
  String roll = '12345678';
  String email = 'alpha@beta.com';
  List encode = [0, 0, 0, 0];
  AppUser({this.uid, this.email, this.name, this.roll, this.encode});
}