import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/joined_users.dart';
import 'package:timevictor/modals/pole.dart';
import 'package:timevictor/screens/home/leaderboard_view.dart';

class PoleCard extends StatelessWidget {
  const PoleCard(
      {Key key, this.pole, this.teamAName, this.teamBName, this.matchID})
      : super(key: key);
  final Pole pole;
  final String teamAName;
  final String teamBName;
  final String matchID;

  bool isJoined(BuildContext context) {
    if (pole.joinedUsers == null) return false;
    bool isJoined = false;
    final uid = Provider.of<Data>(context, listen: false).uid;
    pole.joinedUsers.forEach((element) {
      JoinedUsers joinedUsers = JoinedUsers.fromMap(element);
      if (joinedUsers.userId == uid) {
        isJoined = true;
      }
    });

    return isJoined;
  }

  void viewLeaderBoard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderBoardView(
            teamAName: teamAName,
            teamBName: teamBName,
            pole: pole,
            matchID: matchID,
            isJoined: isJoined(context)),
      ),
    );
  }

  String getButtonText(BuildContext context) {
    String status = Provider.of<Data>(context).matchStatus;
    if (isJoined(context)) {
      return 'Joined';
    } else if (status == 'LIVE') {
      return 'Live';
    } else if (pole.currentCount == pole.maxLimit) {
      return 'Full';
    } else
      return 'Entry';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: GestureDetector(
        onTap: () {
          viewLeaderBoard(context);
        },
        child: Card(
          elevation: 5.0,
          shape: kCardShape(10.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pool Prize',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          '$kRupeeSymbol${pole.currentPrize ?? pole.maxPrize}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            // isJoined(context) ? 'Joined' : 'Entry',
                            getButtonText(context),
                            style: TextStyle(color: Colors.white),
                          ),
                          disabledColor: getButtonText(context) == 'Full'
                              ? Colors.red
                              : Colors.grey,
                          color: kAppBackgroundColor,
                          onPressed: pole.currentCount == pole.maxLimit
                              ? null
                              : () => viewLeaderBoard(context),
                        ),
                        Text('$kRupeeSymbol ${pole.entry}'),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kAppBackgroundColor),
                    backgroundColor: Colors.grey,
                    value: (pole.currentCount / pole.maxLimit),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available spots: ${pole.maxLimit - pole.currentCount}',
                      style: kSpotsTextStyle,
                    ),
                    Text(
                      'Max spots: ${pole.maxLimit}',
                      style: kSpotsTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
