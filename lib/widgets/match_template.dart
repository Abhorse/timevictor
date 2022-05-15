import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/match.dart';
import 'package:timevictor/screens/home/match_pole_view.dart';
import 'package:timevictor/utils/dateTime_formater.dart';
import 'package:timevictor/widgets/custom_clock.dart';
import 'package:timevictor/widgets/team_widget.dart';
import 'dart:math' as math;

class MatchCard extends StatelessWidget {
  const MatchCard({
    Key key,
    this.match,
  });
  final MatchData match;

  String getFomattedTime() {
    return FormattedDateTime.timeLeftFromNow(match.startTime, match.duration);
  }

  Color getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(0.4);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          print(
              '${match.teamAName}  vs  ${match.teamBName}  at ${getFomattedTime()}');
          Provider.of<Data>(context, listen: false)
              .updateMatchStatus(getFomattedTime());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchPolesView(
                teamAName: match.teamAName,
                teamBName: match.teamBName,
                matchID: match.matchID,
                maxTeamStudents: match.maxTeamStudents,
              ),
            ),
          );
        },
        child: Card(
          elevation: 5.0,
          shape: kCardShape(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getRandomColor(),
                    Colors.white,
                    Colors.white,
                    getRandomColor(),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.04, 0.02, 0.96, 0.2],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          match.teamAName,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          //TODO: can add Mega contest pool amount
                          '',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TeamWidget(
                        name: match.teamAName,
                        icon: FontAwesomeIcons.child,
                        imageURL: match.teamAImage,
                      ),
                      Column(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            color: kAppBackgroundColor,
                            size: 18.0,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          CustomClock(
                            matchData: match,
                          ),
                        ],
                      ),
                      TeamWidget(
                        name: match.teamBName,
                        imageURL: match.teamBImage,
                        icon: FontAwesomeIcons.users,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          match.teamBName,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
