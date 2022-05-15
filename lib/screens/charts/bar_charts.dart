import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:timevictor/modals/avg_tm_score.dart';

class BarCharts extends StatelessWidget {
  final List<AvgTMScore> data;

  BarCharts({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<AvgTMScore, String>> series = [
      charts.Series(
        id: "% Avg Score",
        data: data,
        domainFn: (AvgTMScore avgScores, _) => avgScores.exam,
        measureFn: (AvgTMScore avgScores, _) => avgScores.percentage,
        colorFn: (AvgTMScore avgScores, _) => avgScores.color,
      )
    ];
    return charts.BarChart(
      series,
      animate: true,
      behaviors: [
        // new charts.ChartTitle('Top title text',
        //     subTitle: 'Top sub-title text',
        //     behaviorPosition: charts.BehaviorPosition.top,
        //     titleOutsideJustification: charts.OutsideJustification.start,
        //     // Set a larger inner padding than the default (10) to avoid
        //     // rendering the text too close to the top measure axis tick label.
        //     // The top tick label may extend upwards into the top margin region
        //     // if it is located at the top of the draw area.
        //     innerPadding: 18),
        new charts.ChartTitle('Subjects',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 15),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Avg Scored Timemarks in %',
            titleStyleSpec: charts.TextStyleSpec(
              fontSize: 15,
            ),
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
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
