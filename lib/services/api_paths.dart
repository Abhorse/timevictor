class APIPath {
  static String user(String uid) => 'users/$uid';
  static String notification() => 'notifications';
  static String userInfo(String uid) => 'users/$uid';
  static String profilePath() => '/users/profilePictures';
  static String userMatches(String uid) => 'users/$uid/matches';
  static String allMatches() => 'matches/';
  static String polesByMatch(String matchID) => 'matches/$matchID/poles';
  static String getSubjects(String matchID) => 'matches/$matchID/subjects/';
  static String getStudentsByMatch(String matchID) => 'matches/$matchID/teams';
  static String teamAStudents(String matchID) =>
      'matches/$matchID/teamAStudents/';
  static String teamBStudents(String matchID) =>
      'matches/$matchID/teamBStudents/';
  static String addUsersMatch(String matchID, String uid) =>
      'users/$uid/matches/$matchID/'; // add match related stuffs here
  static String addUsersTeamByMatch(
          String matchID, String uid, String teamName) =>
      'users/$uid/matches/$matchID/teams/$teamName';

  static String getTeamsByUser(String uid, String matchID) =>
      'users/$uid/matches/$matchID/teams/';
  static String joinContest(String uid, String matchID) =>
      'users/$uid/matches/$matchID';

  static String addUserToContest(String matchID, String poolID) =>
      'matches/$matchID/poles/$poolID';
  static String joinedUserToPool(
          String matchID, String poolID, String userID) =>
      'matches/$matchID/poles/$poolID/joinedPlayers/$userID';

  static String getJoinedUserToPool(String matchID, String poolID) =>
      'matches/$matchID/poles/$poolID/joinedPlayers/';

  static String getPaymentTransactions(String uid) => 'users/$uid/payments';
  static String getBonusTransactions(String uid) => 'users/$uid/bonus/bonus/transactions';
  static String addPaymentTransaction(String uid, String transactionID) =>
      'users/$uid/payments/$transactionID';
  static String addReferral(String referralCode) =>
      'users/$referralCode/bonus/bonus';
  static String addReferralTransactions(String referralCode, String tId) =>
      '/users/$referralCode/bonus/bonus/transactions/$tId';
}
