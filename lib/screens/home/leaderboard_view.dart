import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/joined_pool.dart';
import 'package:timevictor/modals/joined_pool_list.dart';
import 'package:timevictor/modals/joined_users.dart';
import 'package:timevictor/modals/pole.dart';
import 'package:timevictor/modals/selected_team.dart';
import 'package:timevictor/modals/transaction.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/services/razorpayX.dart';
import 'package:timevictor/utils/helper.dart';
import 'package:timevictor/widgets/circular_loader.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:timevictor/widgets/platform_dropdown.dart';
import 'package:timevictor/widgets/platform_exception_alert_dialog.dart';
import 'package:timevictor/widgets/prize_card.dart';
import 'package:timevictor/widgets/show_payment_dialog.dart';
import 'package:timevictor/widgets/user_pool_score_card.dart';
import 'dart:convert' as convert;

class LeaderBoardView extends StatefulWidget {
  const LeaderBoardView(
      {Key key,
      @required this.teamAName,
      @required this.teamBName,
      @required this.pole,
      this.isJoined,
      this.matchID})
      : super(key: key);

  final String teamAName;
  final String teamBName;
  final String matchID;
  final Pole pole;
  final bool isJoined;

  @override
  _LeaderBoardViewState createState() => _LeaderBoardViewState();
}

class _LeaderBoardViewState extends State<LeaderBoardView> {
  bool isLoading = false;
  static String defaultDropdownManu = '--select--';
  String selectedTeamName = defaultDropdownManu;
  String currentTeamName = '--select--';
  int totalAmountToPay = 0;

  Razorpay _razorpay = Razorpay();

  Future<void> addTransactionToDatabase({
    @required bool isSuccess,
    @required String transactionID,
    @required String orderId,
    @required String paymentMethod,
    @required bool isDebited,
    @required String signature,
    @required int amount,
  }) async {
    var providerData = Provider.of<Data>(context, listen: false);
    Database database = FirestoreDatabase(uid: providerData.uid);
    PayTransaction payTransaction = PayTransaction(
      amount: amount,
      contestName: widget.pole.id,
      isDebited: isDebited,
      isSuccess: isSuccess,
      match: '${widget.teamAName} vs ${widget.teamBName}',
      paymentMethod: paymentMethod,
      time: Timestamp.now(),
      transactionID: transactionID,
      orderId: orderId,
      signature: signature,
    );
    await database.addTransaction(payTransaction);
  }

  Future<void> joinContestFree() async {
    try {
      toggleLoading(true);
      var providerData = Provider.of<Data>(context, listen: false);
      Database database = FirestoreDatabase(uid: providerData.uid);
      JoinedPool joinedPool =
          JoinedPool(poolId: widget.pole.id, teamName: selectedTeamName);
      await database.joinContest(widget.matchID, joinedPool,
          providerData.user.name, providerData.user.profilePicURL);
    } catch (e) {
      PlatformAlertDialog(
        title: 'Unknown Error',
        content: 'Unable to join the contest, Please try again',
        defaultActionText: 'OK',
      ).show(context);
    } finally {
      toggleLoading(false);
      Navigator.pop(context);
    }
  }

  Future<void> joinContestFirebase({
    String paymentID,
    String payMethod,
    String orderId,
    String signature,
    int amount,
  }) async {
    try {
      var providerData = Provider.of<Data>(context, listen: false);
      Database database = FirestoreDatabase(uid: providerData.uid);
      JoinedPool joinedPool =
          JoinedPool(poolId: widget.pole.id, teamName: selectedTeamName);
      await database.joinContest(widget.matchID, joinedPool,
          providerData.user.name, providerData.user.profilePicURL);
      await addTransactionToDatabase(
        isSuccess: true,
        isDebited: true,
        transactionID: paymentID,
        paymentMethod: payMethod,
        orderId: orderId,
        signature: signature,
        amount: amount,
      );
      toggleLoading(false);
    } catch (e) {
      print(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('payment successful');
    if (widget.pole.entry - totalAmountToPay > 0) {
      await payFromCashBonusWallet(widget.pole.entry - totalAmountToPay);
    }
    await joinContestFirebase(
      paymentID: response.paymentId,
      payMethod: 'Online',
      orderId: response.orderId,
      signature: response.signature,
      amount: totalAmountToPay,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toggleLoading(false);
    print('payment failed');
    PlatformAlertDialog(
      title: 'Payment Failed',
      content: 'We are unable to do transaction, please try again',
      defaultActionText: 'OK',
    ).show(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print('payment third party');
    //TODO: Debit (widget.pole.entry - amount)  amount from cashBonus Wallet  and add transaction to database

    toggleLoading(false);
    print('payment failed');
    PlatformAlertDialog(
      title: 'Payment Failed',
      content: 'We are unable to do transartion, please give another try',
      defaultActionText: 'OK',
    ).show(context);
  }

  List<String> getTeamNameList(List<SelectedTeam> selectedTeams) {
    List<String> list = [defaultDropdownManu];
    if (selectedTeams != null) {
      selectedTeams.forEach((team) {
        list.add(team.teamName);
      });
    }

    return list;
  }

  void toggleLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  String getMatchStatus() {
    return Provider.of<Data>(context, listen: false).matchStatus;
  }

  bool isMatchStarted(BuildContext context) {
    String matchStatus = Provider.of<Data>(context, listen: false).matchStatus;
    print(matchStatus);
    if (matchStatus == 'LIVE' || matchStatus == 'Closed') return true;

    return false;
  }

  String getSelectedTeamName(JoinedPoolList joinedPoolList) {
    String teamName = '--select--';
    if (joinedPoolList.joinedPools != null) {
      joinedPoolList.joinedPools.forEach((element) {
        if (element['poolId'] == widget.pole.id) {
          print(element['teamName']);
          teamName = element['teamName'];
        }
      });
      currentTeamName = teamName;
    }
    return teamName;
  }

  Future<void> joinContest(BuildContext context) async {
    bool isTeamSelected = selectedTeamName != defaultDropdownManu;
    bool isSameTeam = currentTeamName == selectedTeamName;

    if (!isTeamSelected) {
      PlatformAlertDialog(
        title: 'Team Not Selected',
        defaultActionText: 'OK',
        content:
            'Please Select a team first. If you dont have a team yet then please create one',
      ).show(context);
      return;
    } else if (isSameTeam) {
      PlatformAlertDialog(
        title: isSameTeam ? 'Already Selected' : 'Already Joined',
        defaultActionText: 'OK',
        content: isSameTeam
            ? 'This team is already selected please select other team. If you dont have a team yet then please create one'
            : 'You have already joined this contest!!',
      ).show(context);
      return;
    }

    if (widget.isJoined) {
      try {
        toggleLoading(true);
        Database database = FirestoreDatabase(
            uid: Provider.of<Data>(context, listen: false).uid);
        database.updateTeamName(
          widget.matchID,
          JoinedPool(poolId: widget.pole.id, teamName: currentTeamName),
          selectedTeamName,
        );
      } catch (e) {
        PlatformAlertDialog(
          title: 'Error On Update Team Name',
          content: e.toString(),
          defaultActionText: 'ok',
        );
      } finally {
        toggleLoading(false);
      }
      return;
    }

    try {
      await PaymentModal(
        context: context,
        joiningAmount: widget.pole.entry,
        payFromWallet: payFromTVWallet,
        joinFree: joinContestFree,
        payOnline: (int amount) {
          toggleLoading(true);
          openPaymentGetway(amount);
        },
      ).show(context);
    } catch (e) {
      toggleLoading(false);
      print(e);
    }
  }

  bool isContestFull() {
    return widget.pole.maxLimit == widget.pole.currentCount;
  }

  String getButtonText(BuildContext context) {
    // if (isContestFull()) return 'Full';
    String status = Provider.of<Data>(context).matchStatus;
    if (status == 'LIVE') return 'LIVE';
    if (status == 'Closed') return 'Closed';
    if (widget.isJoined) {
      return 'Update Team';
    }
    if (isContestFull()) {
      return 'Full';
    } else
      return 'Join';
  }

  List<UserScoreCard> leaderBoardList(List<JoinedUsers> joinedUsers) {
    List<UserScoreCard> list = [];
    if (joinedUsers == null) return list;
    var thisUserId = Provider.of<Data>(context, listen: false).uid;
    if (widget.isJoined) {
      JoinedUsers thisUser =
          joinedUsers.firstWhere((u) => u.userId == thisUserId);
      if (thisUser != null) {
        list.add(UserScoreCard(
          name: thisUser.name,
          rank: '#${thisUser.rank}',
          score: thisUser.quizTotalScore,
          profilePicURL: thisUser.profilePicURL,
          isJoined: true,
          wonPrize: thisUser.wonPrize,
        ));
      }
    }

    joinedUsers.forEach((user) {
      if (user.userId != thisUserId) {
        list.add(UserScoreCard(
          name: user.name,
          rank: '#${user.rank}',
          score: user.quizTotalScore,
          profilePicURL: user.profilePicURL,
          isJoined: false,
          wonPrize: user.wonPrize,
        ));
      }
    });
    return list;
  }

  void openPaymentGetway(int amount) async {
    totalAmountToPay = amount;
    List<String> keys = await RazorPayX.getAPIKey();
    var response = await RazorPayX.createOrder(amount,
        "order_${widget.teamAName}_vs_${widget.teamBName}_${widget.pole.id}");
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      var options = {
        'key': keys[0],
        "order_id": jsonResponse['id'],
        'amount': '${amount * 100}',
        'name': 'Time Victor',
        'description': 'Joining Contest',
        'prefill': {'contact': '', 'email': ''},
        'theme': {'color': kAppBackgoundColorCode},
        // 'image': kTVLogoURL,
      };
      _razorpay.open(options);
    } else {
      toggleLoading(false);
      PlatformAlertDialog(
        title: 'Error Payment Gateway ${response.statusCode}',
        content: 'An error occurred while opening payment gateway ',
        defaultActionText: 'OK',
      ).show(context);
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> payFromCashBonusWallet(int amount) async {
    try {
      await FirestoreDatabase(
              uid: Provider.of<Data>(context, listen: false).uid)
          .debitAmountFromCashBonus(
              amount, '${widget.teamAName} vs ${widget.teamBName}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> payFromTVWallet(int amount) async {
    toggleLoading(true);
    try {
      await FirestoreDatabase(
              uid: Provider.of<Data>(context, listen: false).uid)
          .debitAmountFromTVWallet(amount);
      if (widget.pole.entry - amount > 0) {
        await payFromCashBonusWallet(widget.pole.entry - amount);
      }
      await joinContestFirebase(
        paymentID: '${widget.teamAName}-${widget.teamBName}-${widget.pole.id}',
        payMethod: 'Wallet',
        amount: amount,
      );
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        exception: e,
        title: 'Error',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    Database database =
        FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: Text('${widget.teamAName} vs ${widget.teamBName}'),
        actions: [
          Visibility(
            //TODO: Add share contest functionality
            // visible: getMatchStatus() != 'Closed',
            visible: false,
            child: IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () {
                Helper.shareLink(link: 'https://www.timevictor.com/');
              },
            ),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: Card(
                  shape: kCardShape(10.0),
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pool Prize',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                Text(
                                  '$kRupeeSymbol${widget.pole.currentPrize ?? widget.pole.maxPrize}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  child: Text(
                                    // widget.isJoined ? 'Update Team' : 'Join',
                                    getButtonText(context),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  disabledColor: Colors.red[700],
                                  color: kAppBackgroundColor,
                                  onPressed: isMatchStarted(context) ||
                                          getButtonText(context) == 'Full'
                                      ? null
                                      : () => joinContest(context),
                                ),
                                Text('$kRupeeSymbol ${widget.pole.entry}'),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                kAppBackgroundColor),
                            backgroundColor: Colors.grey,
                            value: (widget.pole.currentCount /
                                widget.pole.maxLimit),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available spots: ${widget.pole.maxLimit - widget.pole.currentCount}',
                              style: kSpotsTextStyle,
                            ),
                            Text(
                              'Max spots: ${widget.pole.maxLimit}',
                              style: kSpotsTextStyle,
                            )
                          ],
                        ),
                        Visibility(
                          visible: widget.isJoined,
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Visibility(
                          visible: widget.isJoined,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                'Selected Team',
                                style: kSpotsTextStyle,
                              )),
                              StreamBuilder<JoinedPoolList>(
                                stream: database.getSelectedTeamByPoleID(
                                    widget.matchID, widget.pole.id),
                                builder: (context, snapshots) {
                                  if (snapshots.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshots.data != null) {
                                      // print(snapshots.data.joinedPools);
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getSelectedTeamName(snapshots.data),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      );
                                    } else
                                      return Text('Error');
                                  } else
                                    return Text('Loading...');
                                },
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !isMatchStarted(context) &&
                              getButtonText(context) != 'Full',
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Visibility(
                          visible: !isMatchStarted(context) &&
                              getButtonText(context) != 'Full',
                          child: SizedBox(
                            height: 35.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select/Update Team'),
                                SizedBox(
                                  width: 20,
                                ),
                                StreamBuilder<List<SelectedTeam>>(
                                  stream: database
                                      .getSelectedTeamsOfMatch(widget.matchID),
                                  builder: (context, snapshots) {
                                    if (snapshots.connectionState ==
                                        ConnectionState.active) {
                                      List<SelectedTeam> selectedTeams =
                                          snapshots.data;
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: PlatformDropdown(
                                            defaultItem: selectedTeamName,
                                            items:
                                                getTeamNameList(selectedTeams),
                                            onchange: (value) {
                                              setState(() {
                                                selectedTeamName = value;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    } else
                                      return Text('Loading..');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 30.0,
                          child: TabBar(
                            indicatorColor: kAppBackgroundColor,
                            indicatorWeight: 5,
                            labelColor: kAppBackgroundColor,
                            unselectedLabelColor: Colors.black38,
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                            tabs: [
                              Tab(
                                child: Text('Awards'),
                              ),
                              Tab(
                                child: Text('Leaderboard'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          PrizeCard(
                            prize: 'PRIZE',
                            rank: 'RANK',
                          ),
                          Expanded(
                            child: ListView(
                              children: widget.pole.prizeBreakupList(),
                            ),
                          ),
                        ],
                      ),
                      widget.pole.joinedUsers.length == 0
                          ? Center(
                              child: Text(
                                'No one has Joined yet!',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : StreamBuilder<List<JoinedUsers>>(
                              stream: database.getJoinedUsersByPoolID(
                                  widget.matchID, widget.pole.id),
                              builder: (context, snapshots) {
                                if (snapshots.connectionState ==
                                    ConnectionState.active) {
                                  //Do something
                                  List<JoinedUsers> players = snapshots.data;
                                  return ListView(
                                    children: leaderBoardList(players),
                                  );
                                } else
                                  return CircularLoader();
                              },
                            )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
