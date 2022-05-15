import 'package:flutter/cupertino.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/modals/joined_users.dart';
import 'package:timevictor/modals/rank_and_prize.dart';
import 'package:timevictor/widgets/prize_card.dart';
import 'package:timevictor/widgets/user_pool_score_card.dart';

class Pole {
  Pole(
      {this.id,
      this.maxLimit,
      this.maxPrize,
      this.currentPrize,
      this.entry,
      this.currentCount,
      this.joinedUsers,
      this.awards});

  final String id;
  final int maxLimit;
  final int maxPrize;
  final int currentPrize;
  final int entry;
  final int currentCount;
  final List<dynamic> joinedUsers;
  final List<dynamic> awards;

  factory Pole.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final int maxLimit = data['maxLimit'];
    final int maxPrize = data['maxPrize'];
    final int entry = data['entry'];
    // final int currentCount = data['currentCount'];
    final int currentCount = data['joinedUsers'].length ?? 0;
    final int currentPrize = data['currentPrize'];
    final List<dynamic> joinedUsers = data['joinedUsers'] ?? null;
    final List<dynamic> awards = data['awards'] ?? null;

    return Pole(
        id: id,
        maxLimit: maxLimit,
        maxPrize: maxPrize,
        entry: entry,
        currentCount: currentCount,
        currentPrize: currentPrize,
        joinedUsers: joinedUsers,
        awards: awards);
  }

  prizeBreakupList() {
    List<Widget> list = [];
    if (this.awards != null && this.awards.length != 0) {
      this.awards.forEach((award) {
        RankPrizePair rankPrizePair = RankPrizePair.fromMap(award);
        list.add(PrizeCard(
            fromRank: rankPrizePair.from,
            toRank: rankPrizePair.to,
            prize:
                '$kRupeeSymbol${(rankPrizePair.prize * 0.01 * (this.currentPrize ?? this.maxPrize)).round()}'));
      });
    } else {
      list.add(Center(
        child: Text(
          'Not Available',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ));
    }

    return list;
  }

  leaderBoardList() {
    List<UserScoreCard> list = [];
    if (this.joinedUsers == null) return list;
    // TODO: If user has joined the match then show it's card at the top as well
    this.joinedUsers.forEach((element) {
      JoinedUsers joinedUsers = JoinedUsers.fromMap(element);
      list.add(UserScoreCard(
        name: joinedUsers.name,
        rank: '#${joinedUsers.rank}',
        score: joinedUsers.quizTotalScore,
      ));
    });
    return list;
  }
}
