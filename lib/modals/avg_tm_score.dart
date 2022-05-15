
import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AvgTMScore {
  final String exam;
  final double percentage;
  final charts.Color color;

  AvgTMScore({
    @required this.exam,
    @required this.percentage,
    @required this.color,
  });
}
