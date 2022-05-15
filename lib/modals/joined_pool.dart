class JoinedPool {
  JoinedPool({this.poolId, this.teamName});
  final String poolId;
  final String teamName;

  factory JoinedPool.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String poolId = data['poolId'];
    final String teamName = data['teamName'];

    return JoinedPool(
      poolId: poolId,
      teamName: teamName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'poolId': poolId,
      'teamName': teamName,
    };
  }
}
