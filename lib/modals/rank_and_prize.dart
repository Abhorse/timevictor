class RankPrizePair {
  final int from;
  final int to;
  final int prize;

  RankPrizePair({
    this.from,
    this.to,
    this.prize,
  });

  factory RankPrizePair.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final int from = data['from'];
    final int to = data['to'];
    final int prize = data['prize'];

    return RankPrizePair(
      from: from,
      to: to,
      prize: prize,
    );
  }
}
