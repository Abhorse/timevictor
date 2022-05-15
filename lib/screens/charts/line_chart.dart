import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:timevictor/screens/charts/consistency.dart';

class CustomLineChat extends StatelessWidget {
  final List<StudentConsistency> data;
  final List<List<StudentConsistency>> chartListData;

  CustomLineChat({
    @required this.data,
    this.chartListData,
  });

  @override
  Widget build(BuildContext context) {
    List<charts.Series<StudentConsistency, num>> series = [
      charts.Series(
        id: "Timevictor Quiz %",
        data: data,
        domainFn: (StudentConsistency studentConsistency, _) =>
            studentConsistency.testNum,
        measureFn: (StudentConsistency studentConsistency, _) =>
            studentConsistency.percentage,
        colorFn: (StudentConsistency studentConsistency, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    ];
    return charts.LineChart(
      series,
      animate: true,
      defaultRenderer: new charts.LineRendererConfig(includePoints: true),
      behaviors: [
        new charts.ChartTitle(
          'Last 5 tests',
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleStyleSpec:
              charts.TextStyleSpec(fontSize: 15, fontWeight: "bold"),
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
        new charts.ChartTitle(
          '% Timemarks Score in Tests',
          titleStyleSpec: charts.TextStyleSpec(fontSize: 15),
          behaviorPosition: charts.BehaviorPosition.start,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
        new charts.SeriesLegend(
          position: charts.BehaviorPosition.top,
          desiredMaxRows: 3,
          desiredMaxColumns: 2,
          showMeasures: true,
        )
      ],
    );
  }
}
