import 'package:flutter/foundation.dart';

class SelectedTeam {
  SelectedTeam({
    @required this.captainId,
    this.studentsId,
    @required this.teamName,
    @required this.viceCaptainId,
    @required this.thirdBestId,
  });
  final String teamName;
  final String captainId;
  final String viceCaptainId;
  final String thirdBestId;
  final List<dynamic> studentsId;

  factory SelectedTeam.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String captainId = data['captainId'];
    final String teamName = data['teamName'];
    final List<dynamic> studentsId = data['studentsId'];
    final String viceCaptainId = data['viceCaptainId'] ?? 'NA';
    final String thirdBestId = data['thirdBestId'] ?? 'NA';

    return SelectedTeam(
        teamName: teamName,
        captainId: captainId,
        studentsId: studentsId,
        viceCaptainId: viceCaptainId,
        thirdBestId: thirdBestId);
  }
  Map<String, dynamic> toMap() {
    return {
      'teamName': teamName,
      'captainId': captainId,
      'studentsId': studentsId,
      'viceCaptainId': viceCaptainId,
      'thirdBestId': thirdBestId
    };
  }
}
