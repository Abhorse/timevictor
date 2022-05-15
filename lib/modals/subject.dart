import 'package:flutter/foundation.dart';

class Subject {
  String subject;
  int minStudents;
  int maxStudents;

  Subject({@required this.subject, this.minStudents, this.maxStudents});

  factory Subject.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String subject = data['subject'];
    final int minStudents = data['minStudents'];
    final int maxStudents = data['maxStudents'];
    return Subject(
      subject: subject,
      minStudents: minStudents,
      maxStudents: maxStudents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'minStudents': minStudents,
      'maxStudents': maxStudents
    };
  }
}
