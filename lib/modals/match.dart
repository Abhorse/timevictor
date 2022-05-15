import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:timevictor/modals/subject.dart';
import 'package:timevictor/modals/team.dart';

class MatchData {
  final String matchID;
  final String teamAName;
  final String teamBName;
  final List<Subject> subjects;
  final Timestamp startTime;
  final TeamData teamA;
  final TeamData teamB;
  final int duration;
  final String teamAImage;
  final String teamBImage;
  final bool showToAll;
  final int maxTeamStudents;

  MatchData({
    @required this.matchID,
    @required this.teamAName,
    @required this.teamBName,
    this.subjects,
    this.teamA,
    this.teamB,
    this.startTime,
    this.duration,
    this.teamAImage,
    this.teamBImage,
    this.showToAll,
    this.maxTeamStudents,
  })  : assert(matchID != null),
        assert(teamAName != null),
        assert(teamBName != null);

  factory MatchData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String matchID = data['matchID'];
    final String teamAName = data['teamAName'];
    final String teamBName = data['teamBName'];
    final Timestamp startTime = data['startTime'];
    final int duration = data['duration'];
    final String teamAImage = data['teamAImage'];
    final String teamBImage = data['teamBImage'];
    final bool showToAll = data['showToAll'] ?? true;
    final int maxTeamStudents = data['maxTeamStudents'] ?? 11;

    return MatchData(
      matchID: matchID,
      teamAName: teamAName,
      teamBName: teamBName,
      startTime: startTime,
      duration: duration,
      teamAImage: teamAImage,
      teamBImage: teamBImage,
      showToAll: showToAll,
      maxTeamStudents: maxTeamStudents
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'matchID': matchID,
      'teamAName': teamAName,
      'teamBName': teamBName,
    };
  }
}
