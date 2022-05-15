import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';

class UserScoreCard extends StatelessWidget {
  const UserScoreCard(
      {Key key,
      this.name,
      this.rank,
      this.score,
      this.profilePicURL,
      this.isJoined,
      this.wonPrize})
      : super(key: key);

  final String name;
  final String rank;
  final double score;
  final String profilePicURL;
  final bool isJoined;
  final int wonPrize;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor:
          isJoined != null && isJoined ? kAppBackgroundColor : Colors.grey,
      elevation: isJoined != null && isJoined ? 10.0 : 1.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                profilePicURL != null && profilePicURL.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(profilePicURL),
                        backgroundColor: kAppBackgroundColor,
                      )
                    : CircleAvatar(
                        backgroundColor: kAppBackgroundColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'NA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      score.toString(),
                      style: TextStyle(color: kAppBackgroundColor),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Visibility(
                  visible: wonPrize != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prize',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0),
                      ),
                      Text(
                        '$kRupeeSymbol$wonPrize.00',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  rank,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
