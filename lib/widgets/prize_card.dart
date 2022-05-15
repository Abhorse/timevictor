import 'package:flutter/material.dart';

class PrizeCard extends StatelessWidget {
  const PrizeCard({
    Key key,
    this.rank,
    this.prize,
    this.fromRank,
    this.toRank,
  }) : super(key: key);

  final String rank;
  final int fromRank;
  final int toRank;
  final String prize;

  String rankRange() {
    if (rank != null) return rank;
    if (fromRank == toRank)
      return '#$fromRank';
    else
      return '#$fromRank-$toRank';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              rankRange(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              prize,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
