import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/modals/match.dart';
import 'package:timevictor/utils/dateTime_formater.dart';
import 'package:timevictor/widgets/circular_loader.dart';
import 'package:timevictor/widgets/match_template.dart';

class MatchListWidget extends StatelessWidget {
  const MatchListWidget({
    Key key,
    this.stream,
    this.emptyListMessage,
    this.isLiveMatche,
  }) : super(key: key);

  final Stream stream;
  final String emptyListMessage;
  final bool isLiveMatche;

  List<Widget> getMatchList(List<MatchData> matches) => matches
      .map((match) => MatchCard(
            match: match,
          ))
      .toList();

  bool isLiveMatchData(MatchData matchData) {
    return FormattedDateTime.formate(matchData.startTime, matchData.duration) ==
        'LIVE';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MatchData>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<MatchData> allMatches = snapshot.data;
          List<MatchData> matches = isLiveMatche
              ? allMatches.where((m) => isLiveMatchData(m)).toList()
              : allMatches.toList();
          if (snapshot.data == null || matches.length == 0)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_neutral,
                  color: kAppBackgroundColor,
                  size: 50.0,
                ),
                Text('No $emptyListMessage'),
              ],
            );
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Row(
                  children: [
                    Text(
                      emptyListMessage,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: getMatchList(matches),
                ),
              ),
            ],
          );
        } else
          return CircularLoader();
      },
    );
  }
}
