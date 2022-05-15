import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timevictor/modals/bonus.dart';
import 'package:timevictor/modals/bonus_transaction.dart';
import 'package:timevictor/modals/joined_pool.dart';
import 'package:timevictor/modals/joined_pool_list.dart';
import 'package:timevictor/modals/joined_users.dart';
import 'package:timevictor/modals/match.dart';
import 'package:timevictor/modals/notification.dart';
import 'package:timevictor/modals/payment.dart';
import 'package:timevictor/modals/pole.dart';
import 'package:timevictor/modals/razorpayX_details.dart';
import 'package:timevictor/modals/selected_team.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/modals/subject.dart';
import 'package:timevictor/modals/transaction.dart';
import 'package:timevictor/modals/user_info.dart';
import 'package:timevictor/services/api_paths.dart';
import 'package:timevictor/services/firestore_service.dart';

abstract class Database {
  Future<void> createUser(UserInfo userData);

  Future<void> updateUserInfo(UserInfo userInfo);

  Future<String> uploadImage(File image);

  Stream<UserInfo> streamUserInfo();

  void readMatches();

  UserInfo getUserInfo();

  Stream<List<MatchData>> getActiveMatches();

  Stream<List<Pole>> getPolesByMatch(String matchID);

  Stream<List<Subject>> getSubjects(String matchID);

  Stream<List<Student>> getTeamAStudents(String matchID);

  Stream<List<Student>> getTeamBStudents(String matchID);

  Future<void> createTeam(SelectedTeam selectedTeam, String matchID);

  Stream<List<SelectedTeam>> getSelectedTeamsOfMatch(String matchID);

  Future<void> joinContest(
      String matchID, JoinedPool joinedPool, String name, String profilePicURL);

  Stream<JoinedPoolList> getSelectedTeamByPoleID(String matchID, String poolID);

  Future<void> updateTeamName(
      String matchID, JoinedPool joinedPool, String newTeamName);

  Stream<DocumentSnapshot> getUsersJoinedMatches();

  Stream<List<MatchData>> getUsersMatches(List<dynamic> usersMatches);

  Stream<List<MatchData>> getLiveMatches();

  Stream<List<JoinedUsers>> getJoinedUsersByPoolID(
      String matchID, String poolID);

  Stream<List<PayTransaction>> getAllPaymentTransactions();

  Future<int> getWalletBalance();
  Stream<BonusWallet> getBonusWalletBalance();
  Future<double> getCashBonusBalance();
  Stream<List<BonusTransaction>> getBonusTransactions();

  Future<void> addTransaction(PayTransaction payTransaction);

  Future<void> debitAmountFromTVWallet(int amount);
  Future<void> debitAmountFromCashBonus(int amount, String remark);

  Stream<RazorpayXPayout> getRazorpayXData();

  Future<void> createRazorpayXData(RazorpayXPayout razorpayXPayout);

  Future<void> createRazorpayXFundData(RazorpayXPayout razorpayXPayout);

  Future<Stream<List<MatchData>>> getUsersMatchesUpdate();

  Stream<List<NotificationData>> getAllNotifications();

  Future<void> addReferralBonus(
      String referralCode, String name, double bonusAmount);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final _service = FirestoreService.instance;

  Future<void> createUser(UserInfo userData) async =>
      await _service.setData(path: APIPath.user(uid), data: userData.toMap());

  Future<void> updateUserInfo(UserInfo userInfo) async => await _service
      .updateDoc(path: APIPath.user(uid), data: userInfo.toMapUpdate());

  Future<String> uploadImage(File image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/profilePictures/profile_$uid');

    StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    return await taskSnapshot.ref.getDownloadURL();
    // Uri location = (await uploadTask.).downloadUrl;
  }

  Future<void> createTeam(SelectedTeam selectedTeam, String matchID) async {
    DocumentSnapshot doc = await Firestore.instance
        .document(APIPath.addUsersMatch(matchID, uid))
        .get();

    if (!doc.exists) {
      await _service.setData(
        path: APIPath.addUsersMatch(matchID, uid),
        data: {"matchID": matchID},
      );

      // await _service.updateDoc(
      //   path: APIPath.addUsersMatch(matchID, uid),
      //   data: {"matchID": matchID},
      // );
    }

    await _service.setData(
      path: APIPath.addUsersTeamByMatch(matchID, uid, selectedTeam.teamName),
      data: selectedTeam.toMap(),
    );
  }

  Future<void> joinContest(String matchID, JoinedPool joinedPool, String name,
      String profilePicURL) async {
    await _service.updateArrayData(
      path: APIPath.userInfo(uid),
      field: 'joinedMatches',
      value: matchID,
    );
    await _service.updateArrayData(
        path: APIPath.joinContest(uid, matchID),
        field: 'joinedPools',
        value: joinedPool.toMap());
    // have to remove this
    await _service.updateArrayData(
        path: APIPath.addUserToContest(matchID, joinedPool.poolId),
        field: 'joinedUsers',
        value: JoinedUsers(
          rank: 0,
          name: name,
          userId: uid,
          quizTotalScore: 0.0,
          profilePicURL: profilePicURL,
        ).toMap());

    await _service.setData(
      path: APIPath.joinedUserToPool(matchID, joinedPool.poolId, uid),
      data: JoinedUsers(
        rank: 0,
        name: name,
        userId: uid,
        quizTotalScore: 0.0,
        profilePicURL: profilePicURL,
      ).toMap(),
    );
  }

  Stream<List<JoinedUsers>> getJoinedUsersByPoolID(
          String matchID, String poolID) =>
      _service.ordereCollectionStream(
        path: APIPath.getJoinedUserToPool(matchID, poolID),
        builder: (data) => JoinedUsers.fromMap(data),
        orderBy: 'rank',
        descending: false,
      );

  Stream<UserInfo> streamUserInfo() => _service.documentStream(
        path: APIPath.userInfo(uid),
        builder: (data) => UserInfo.fromMap(data),
      );

  Future<UserInfo> getUserInformation() async {
    var userData =
        await Firestore.instance.document(APIPath.userInfo(uid)).get();
    // int walletBalance = userData.data['walletBalance'] ?? 0;
    return UserInfo.fromMap(userData.data);
  }

  UserInfo getUserInfo() {
    final path = APIPath.userInfo(uid);
    final reference = Firestore.instance.document(path);
    final snapshots = reference.snapshots();
    UserInfo user;
    snapshots.listen((snapshot) {
      user = UserInfo.fromMap(snapshot.data);
    });
    return user;
  }

  // Stream<List<MatchData>> getActiveMatches() => _service.collectionStream(
  //       path: APIPath.allMatches(),
  //       builder: (data) => MatchData.fromMap(data),
  //     );
  Stream<List<MatchData>> getActiveMatches() =>
      _service.collectionStreamConditionally(
        path: APIPath.allMatches(),
        builder: (data) => MatchData.fromMap(data),
        field: 'startTime',
        value: DateTime.now(),
      );

  // Stream<List<MatchData>> getLiveMatches() =>
  //     _service.collectionStreamConditionally(
  //         path: APIPath.allMatches(),
  //         builder: (data) => MatchData.fromMap(data),
  //         field: 'startTime',
  //         value: DateTime.now().add(Duration(minutes: -30)));

  Stream<List<MatchData>> getLiveMatches() {
    final reference = Firestore.instance
        .collection(APIPath.allMatches())
        .where('startTime', isLessThan: DateTime.now())
        .where('startTime',
            isGreaterThan: DateTime.now().add(Duration(hours: -3)))
        .orderBy('startTime', descending: false);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.documents
          .map((snapshot) => MatchData.fromMap(snapshot.data))
          .toList(),
    );
  }

  Stream<List<MatchData>> getLiveMatchesUpdated() {
    final reference = Firestore.instance
        .collection(APIPath.allMatches())
        .where('startTime', isLessThan: DateTime.now())
        .where('startTime',
            isGreaterThan: DateTime.now().add(Duration(hours: -3)))
        .orderBy('startTime', descending: false);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.documents
          .map((snapshot) => MatchData.fromMap(snapshot.data))
          .toList(),
    );
  }

  Stream<DocumentSnapshot> getUsersJoinedMatches() {
    DocumentReference document =
        Firestore.instance.document(APIPath.userInfo(uid));
    print('called API: ${APIPath.userInfo(uid)} from getUsersJoinedMatches');
    final snapshots = document.snapshots();
    return snapshots;
  }

  Stream<List<MatchData>> getUsersMatches(List<dynamic> usersMatches) {
    // var userData =
    //     await Firestore.instance.document(APIPath.userInfo(uid)).get();
    // int walletBalance = userData.data['walletBalance'];

    final reference = Firestore.instance
        .collection(APIPath.allMatches())
        .where('matchID', whereIn: usersMatches);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.documents
          .map((snapshot) => MatchData.fromMap(snapshot.data))
          .toList(),
    );
  }

  Future<Stream<List<MatchData>>> getUsersMatchesUpdate() async {
    var userData =
        await Firestore.instance.document(APIPath.userInfo(uid)).get();
    // UserInfo  userInfo = userData.data['walletBalance'];
    List<dynamic> joinedMatches = userData.data['walletBalance'];

    final reference = Firestore.instance
        .collection(APIPath.allMatches())
        .where('matchID', whereIn: joinedMatches);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.documents
          .map((snapshot) => MatchData.fromMap(snapshot.data))
          .toList(),
    );
  }

  Stream<List<Pole>> getPolesByMatch(String matchID) =>
      _service.ordereCollectionStream(
        path: APIPath.polesByMatch(matchID),
        builder: (data) => Pole.fromMap(data),
        orderBy: 'maxPrize',
        descending: true,
      );

  Stream<List<Subject>> getSubjects(String matchID) =>
      _service.collectionStream(
        path: APIPath.getSubjects(matchID),
        builder: (data) => Subject.fromMap(data),
      );

  Stream<List<Student>> getTeamAStudents(String matchID) =>
      _service.collectionStream(
        path: APIPath.teamAStudents(matchID),
        builder: (data) => Student.fromMap(data),
      );

  Stream<List<Student>> getTeamBStudents(String matchID) =>
      _service.collectionStream(
        path: APIPath.teamBStudents(matchID),
        builder: (data) => Student.fromMap(data),
      );

  Stream<List<SelectedTeam>> getSelectedTeamsOfMatch(String matchID) =>
      _service.collectionStream(
        path: APIPath.getTeamsByUser(uid, matchID),
        builder: (data) => SelectedTeam.fromMap(data),
      );

  Stream<JoinedPoolList> getSelectedTeamByPoleID(
          String matchID, String poolID) =>
      _service.documentStream(
        path: APIPath.joinContest(uid, matchID),
        builder: (data) => JoinedPoolList.fromMap(data),
      );

  Future<void> updateTeamName(
      String matchID, JoinedPool joinedPool, String newTeamName) async {
    final path = APIPath.addUsersMatch(matchID, uid);
    DocumentReference docRef = Firestore.instance.document(path);
    docRef.updateData({
      'joinedPools': FieldValue.arrayRemove([joinedPool.toMap()])
    });
    docRef.updateData({
      'joinedPools': FieldValue.arrayUnion([
        JoinedPool(poolId: joinedPool.poolId, teamName: newTeamName).toMap()
      ])
    });
  }

  Stream<List<PayTransaction>> getAllPaymentTransactions() =>
      _service.ordereCollectionStream(
        descending: true,
        orderBy: 'time',
        path: APIPath.getPaymentTransactions(uid),
        builder: (data) => PayTransaction.fromMap(data),
      );

  Future<void> addTransaction(PayTransaction payTransaction) async {
    _service.setData(
      path: APIPath.addPaymentTransaction(uid, payTransaction.orderId),
      data: payTransaction.toMap(),
    );
  }

  Stream<WalletBalance> getCurrentWalletBalance() => _service.documentStream(
        path: APIPath.userInfo(uid),
        builder: (data) => WalletBalance.fromMap(data),
      );

  Future<int> getWalletBalance() async {
    var userData =
        await Firestore.instance.document(APIPath.userInfo(uid)).get();
    int walletBalance = userData.data['walletBalance'] ?? 0;
    return walletBalance;
  }

  Future<void> debitAmountFromTVWallet(int amount) async {
    var userData =
        await Firestore.instance.document(APIPath.userInfo(uid)).get();
    int walletBalance = userData.data['walletBalance'];
    await Firestore.instance
        .document(APIPath.userInfo(uid))
        .updateData({'walletBalance': walletBalance - amount});
  }

  Future<void> debitAmountFromCashBonus(int amount, String remark) async {
    var bonusWallet =
        await Firestore.instance.document(APIPath.addReferral(uid)).get();
    double bonusBalance = bonusWallet.data['bonusBalance'];
    int totalTransactions = bonusWallet.data['totalTransactions'];

    await _service.updateDoc(
      path: APIPath.addReferral(uid),
      data: {
        'bonusBalance': bonusBalance - amount,
        'totalTransactions': totalTransactions + 1,
      },
    );

    await _service.setData(
      path: APIPath.addReferralTransactions(
          uid, 'bonus-${totalTransactions + 1}'),
      data: {
        'by': remark,
        'date': Timestamp.now(),
        'isCredited': false,
        'bonusAmount': amount,
        'id': 'bonus-${totalTransactions + 1}',
      },
    );
  }

  Stream<BonusWallet> getBonusWalletBalance() => _service.documentStream(
        path: APIPath.addReferral(uid),
        builder: (data) => BonusWallet.fromMap(data),
      );

  Future<double> getCashBonusBalance() async {
    var bonusWallet =
        await Firestore.instance.document(APIPath.addReferral(uid)).get();
    double bonusBalance = 0;
    if (bonusWallet != null && bonusWallet.data != null) {
      bonusBalance = bonusWallet.data['bonusBalance'] ?? 0;
    }
    return bonusBalance;
  }

  Stream<List<BonusTransaction>> getBonusTransactions() =>
      _service.ordereCollectionStream(
        path: APIPath.getBonusTransactions(uid),
        builder: (data) => BonusTransaction.fromMap(data),
        orderBy: 'date',
        descending: true,
      );

  Stream<RazorpayXPayout> getRazorpayXData() => _service.documentStream(
        path: APIPath.user(uid),
        builder: (data) => RazorpayXPayout.fromMap(data),
      );

  Future<void> createRazorpayXData(RazorpayXPayout razorpayXPayout) =>
      _service.updateDoc(
        path: APIPath.user(uid),
        data: razorpayXPayout.toMap(),
      );

  Future<void> createRazorpayXFundData(RazorpayXPayout razorpayXPayout) =>
      _service.updateDoc(
        path: APIPath.user(uid),
        data: razorpayXPayout.toMapFundAccountData(),
      );

  Stream<List<NotificationData>> getAllNotifications() =>
      _service.ordereCollectionStream(
        path: APIPath.notification(),
        builder: (data) => NotificationData.fromMap(data),
        orderBy: 'date',
        descending: true,
      );

  Future<void> addReferralBonus(
      String referralCode, String name, double bonusAmount) async {
    var bonusWallet = await Firestore.instance
        .document(APIPath.addReferral(referralCode))
        .get();
    double bonusBalance = 0;
    int totalTransactions = 0;
    if (bonusWallet != null && bonusWallet.data != null) {
      bonusBalance = bonusWallet.data['bonusBalance'] ?? 0;
      totalTransactions = bonusWallet.data['totalTransactions'] ?? 0;

      await _service.updateDoc(path: APIPath.addReferral(referralCode), data: {
        'bonusBalance': bonusBalance + bonusAmount,
        'totalTransactions': totalTransactions + 1,
      });
    } else {
      await _service.setData(path: APIPath.addReferral(referralCode), data: {
        'bonusBalance': bonusBalance + bonusAmount,
        'totalTransactions': totalTransactions + 1,
      });
    }
    await _service.setData(
      path: APIPath.addReferralTransactions(
          referralCode, 'bonus-${totalTransactions + 1}'),
      data: {
        'by': name,
        'date': Timestamp.now(),
        'isCredited': true,
        'bonusAmount': bonusAmount,
        'id': 'bonus-${totalTransactions + 1}',
      },
    );
  }

  void readMatches() {
    final path = APIPath.userMatches(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    snapshots.listen((snapshot) {
      snapshot.documents.forEach((matches) => print(matches.data));
    });
    // {snapshot.documents.forEach((matches) => print(matches.data))});
  }
}
