import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/services/database.dart';

import '../alert_messages.dart';
import '../constants.dart';
import 'circular_loader.dart';
import 'match_list_widget.dart';

class JoinedMatchesListWidgets extends StatelessWidget {
  const JoinedMatchesListWidgets({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: 
          Provider.of<Database>(context, listen: false).getUsersJoinedMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<dynamic> matches = snapshot.data['joinedMatches'];
          if (snapshot.data != null &&
              snapshot.data['joinedMatches'] != null &&
              matches.length != 0) {
            return MatchListWidget(
              stream: Provider.of<Database>(context, listen: false)
                  .getUsersMatches(matches),
              emptyListMessage: kJoinedMatchMsg,
              isLiveMatche: false,
            );
          } else
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_neutral,
                  color: kAppBackgroundColor,
                  size: 50.0,
                ),
                Text(kNoJoinedMatchMsg),
              ],
            );
        } else
          return CircularLoader();
      },
    );
  }
}