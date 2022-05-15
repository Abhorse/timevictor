import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timevictor/modals/match.dart';
import 'package:timevictor/utils/dateTime_formater.dart';

class CustomClock extends StatefulWidget {
  final MatchData matchData;

  const CustomClock({Key key, @required this.matchData}) : super(key: key);
  @override
  _CustomClockState createState() => _CustomClockState();
}

class _CustomClockState extends State<CustomClock> {
  // Timer timer;
  String _time;
  @override
  void initState() {
    super.initState();
    _time = FormattedDateTime.timeLeftFromNow(
      widget.matchData.startTime,
      widget.matchData.duration,
    );
    // timer =
    //     Timer.periodic(Duration(seconds: 1), (Timer t) => _getFomattedTime());
  }

  // void _getFomattedTime() {
  //   setState(() {
  //     _time = FormattedDateTime.timeLeftFromNow(
  //       widget.matchData.startTime,
  //       widget.matchData.duration,
  //     );
  //   });
  // }

  @override
  void dispose() {
    print('disposing clock');
    // timer.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    print('disposing clock');
    // TODO: implement deactivate
    // timer.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _time,
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
