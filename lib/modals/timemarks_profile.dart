import 'package:flutter/material.dart';
import 'package:timevictor/modals/avg_tm_score.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:timevictor/screens/charts/consistency.dart';

class TimemarksProfile {
  int id;
  String name;
  String imageURL;
  double timemarksPoints;
  int attemptedQuizCount;
  String about;
  String recommendedSubject;
  String tenthBoard;
  double tenthPercentage;
  bool isTenthVerified;

  String twelfthBoard;
  double twelfthPercentage;
  bool istwelfthVerified;

  String graduationBoard;
  double graduationPercentage;
  bool isgraduationVerified;

  List<AvgTMScore> performanceData;
  List<StudentConsistency> consistencyData;

  TimemarksProfile(
      {this.id,
      this.name,
      this.imageURL,
      this.timemarksPoints,
      this.recommendedSubject,
      this.attemptedQuizCount,
      this.about,
      this.tenthBoard,
      this.tenthPercentage,
      this.isTenthVerified,
      this.twelfthBoard,
      this.twelfthPercentage,
      this.istwelfthVerified,
      this.graduationBoard,
      this.graduationPercentage,
      this.isgraduationVerified,
      this.consistencyData,
      this.performanceData});

  factory TimemarksProfile.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    dynamic details = data['detail'];
    List<dynamic> chartData = data['subject_wise']['list'];
    List<dynamic> consistencyData = data['subject_quiz_wise']['list'];
    List<AvgTMScore> performanceData = chartData.map((sub) {
      return AvgTMScore(
        exam: sub['subject_name'],
        percentage:
            sub['right_percentage'] > 100 ? 100 : sub['right_percentage'],
        color: charts.ColorUtil.fromDartColor(Colors.blue),
      );
    }).toList();
    int i = 0;
    List<StudentConsistency> consistencyChartData = consistencyData.map((sub) {
      i++;
      return StudentConsistency(
        exam: sub['subject_name'],
        percentage:
            sub['right_percentage'] > 100 ? 100 : sub['right_percentage'],
        testNum: i,
      );
    }).toList();

    return TimemarksProfile(
      id: int.parse(details['ID']),
      name: details['name'],
      imageURL: details['image'],
      timemarksPoints: double.parse(details['timemarksavg_points']),
      attemptedQuizCount: details['quizzes_attempted'],
      recommendedSubject: details['subject_names'] != ''
          ? details['subject_names']
          : 'Not Recommended',
      tenthBoard: details['tenth_board'],
      tenthPercentage: details['tenth_percentage'] != null
          ? double.parse(details['tenth_percentage'])
          : null,
      isTenthVerified: details['tenth_status'] != '0',
      twelfthBoard: details['twelfth_board'],
      twelfthPercentage: details['twelfth_percentage'] != null
          ? double.parse(details['twelfth_percentage'])
          : null,
      istwelfthVerified: details['twelfth_status'] != '0',
      graduationBoard: details['graduation_board'],
      graduationPercentage: details['graduation_percentage'] != null
          ? double.parse(details['graduation_percentage'])
          : null,
      isgraduationVerified: details['graduation_status'] != '0',
      consistencyData: consistencyChartData,
      performanceData: performanceData,
    );
  }
}

class AcademicsDetails {
  String tenthBoard;
  double tenthPercentage;
  bool isTenthVerified;

  String twelfthBoard;
  double twelfthPercentage;
  bool istwelfthVerified;

  String graduationBoard;
  double graduationPercentage;
  bool isgraduationVerified;
}
