class JoinedPoolList {
  final List<dynamic> joinedPools;

  JoinedPoolList({this.joinedPools});

  factory JoinedPoolList.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    final List<dynamic> joinedPools = data['joinedPools'];

    return JoinedPoolList(
      joinedPools: joinedPools,
    );
  }
}
