import 'package:flutter/foundation.dart';

class StudentConsistency {
  final double percentage;
  final String exam;
  final int testNum;

  StudentConsistency({
    @required this.percentage,
    @required this.testNum,
    this.exam,
  });
}
