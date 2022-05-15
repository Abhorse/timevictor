import 'package:flutter/foundation.dart';

class Student {
  final String id;
  final String name;
  final String points;
  final String subject;
  final String profilePic;
  final dynamic quizMarks;

  Student({
    @required this.name,
    @required this.points,
    @required this.subject,
    @required this.id,
    this.profilePic,
    this.quizMarks,
  });

  factory Student.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final String name = data['name'];
    final String points = data['score'];
    final String subject = data['subject'];
    final String profilePic = data['profilePic'];
    final dynamic quizMarks = data['quizMarks'] ?? 0.0;

    return Student(
      id: id,
      name: name,
      points: points,
      subject: subject,
      profilePic: profilePic,
      quizMarks: quizMarks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'points': points,
      'subject': subject,
    };
  }
}
