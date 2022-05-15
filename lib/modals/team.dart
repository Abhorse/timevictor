import 'package:flutter/foundation.dart';
import 'package:timevictor/modals/student.dart';

class TeamData {
  final List<Student> students;
  final String teamName;

  TeamData({
    @required this.students,
    @required this.teamName,
  });

  factory TeamData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final List<Student> students = data['students'];
    final String teamName = data['teamName'];
    
    return TeamData(
      students: students,
      teamName: teamName,
    );
  }
}
