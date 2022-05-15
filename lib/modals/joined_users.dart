class JoinedUsers {
  final String userId;
  final String name;
  final int rank;
  final double quizTotalScore;
  final String profilePicURL;
  final int wonPrize;

  JoinedUsers({
    this.userId,
    this.rank,
    this.name,
    this.quizTotalScore,
    this.profilePicURL,
    this.wonPrize,
  });

  factory JoinedUsers.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final int rank = data['rank'];
    final dynamic quizTotalScore = data['quizTotalScore'];
    final String userId = data['userId'];
    final String profilePicURL = data['profilePicURL'] ?? '';
    final int wonPrize = data['prize'] ?? null;

    return JoinedUsers(
      rank: rank,
      name: name,
      quizTotalScore: quizTotalScore.toDouble(),
      userId: userId,
      profilePicURL: profilePicURL,
      wonPrize: wonPrize,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rank': rank,
      'name': name,
      'quizTotalScore': quizTotalScore,
      'profilePicURL': profilePicURL,
    };
  }
}
