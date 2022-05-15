import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/alert_messages.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/data/shared_preferences.dart';
import 'package:timevictor/modals/match.dart';
import 'package:timevictor/modals/user_info.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/services/notification_service.dart';
import 'package:timevictor/utils/dateTime_formater.dart';
import 'package:timevictor/widgets/joined_matches_list_widget.dart';
import 'package:timevictor/widgets/match_list_widget.dart';
import 'package:timevictor/widgets/match_template.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import '../notification.dart';
import 'drawer_view.dart';

class HomeScreen extends StatefulWidget {
  // TODO: Read user data from firebase and update provider<Data> when app get started
  final bool isJustLoggedIn;

  const HomeScreen({this.isJustLoggedIn});

  // HomeScreen({this.isJustLoggedIn})
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> setUserInfoInProvider(BuildContext context) async {
    try {
      SharedPref sharedPref = SharedPref();
      final provider = Provider.of<Data>(context, listen: false);
      if (provider.user.name == null ||
          provider.user.name.isEmpty ||
          provider.user.name == 'NA') {
        UserInfo userInfo = await sharedPref.getUserInfo();
        provider.updateUserInfo(userInfo);
        provider.updateUID(await sharedPref.getUID());
        provider.updatePhoneNumber(await sharedPref.getPhoneNumber());
      }
    } catch (e) {
      print(e);
    }
  }

  List<Widget> getMatchList(List<MatchData> matches) {
    List<Widget> matchList = [];
    matches.forEach((match) {
      matchList.add(MatchCard(
        match: match,
        // teamAName: match.teamAName,
        // teamBName: match.teamBName,
        // time: FormattedDateTime.formate(match.startTime, match.duration),
        // matchID: match.matchID,
        // teamAImage: match.teamAImage,
        // teamBImage: match.teamBImage,
      ));
    });
    return matchList;
  }

  int _selectedIndex = 0;

  Widget getActiveMatches(BuildContext context) {
    return MatchListWidget(
      stream: Provider.of<Database>(context, listen: false).getActiveMatches(),
      emptyListMessage: kNoUpcomingMatcheMsg,
      isLiveMatche: false,
    );
  }

  Widget getLiveMatches(BuildContext context) {
    //TODO: get live matches according to there own live time (currenlty default time is 30 mins)
    return MatchListWidget(
      stream: Provider.of<Database>(context, listen: false).getLiveMatches(),
      emptyListMessage: kNoLiveMatcheMsg,
      isLiveMatche: true,
    );
  }

  Widget getUsersJoinedMatches(BuildContext context) {
    return JoinedMatchesListWidgets();
  }

  Widget getIndexedWidget(BuildContext context) {
    List<Widget> _widgets = [
      getActiveMatches(context),
      getLiveMatches(context),
      getUsersJoinedMatches(context)
    ];

    return _widgets.elementAt(_selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _confirmCloseAction(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: kConfirmCloseAppTitle,
      content: kConfirmCloseAppMsg,
      cancelActionText: 'Cancel',
      defaultActionText: 'Yes, Close',
    ).show(context);
    return new Future(() => didRequestSignOut);
  }

  @override
  void initState() {
    super.initState();
    PushNotificationService().subscribeToNotification();
    PushNotificationService().initialise(context);
  }

  @override
  Widget build(BuildContext context) {
    setUserInfoInProvider(context).then((value) {
      // setState(() {});
    });
    return WillPopScope(
      onWillPop: () {
        return _confirmCloseAction(context);
      },
      child: Container(
        color: kAppBackgroundColor,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Center(
                child: AppBarTitles.home,
              ),
              backgroundColor: kAppBackgroundColor,
              actions: <Widget>[
                Stack(
                  children: [
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_none,
                          size: 30.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyNotifications(),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 13.0,
                      left: 25.0,
                      child: Container(
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.sync,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                )
              ],
            ),
            drawer: DrawerView(
              reload: () {
                setState(() {});
              },
            ),
            body: Container(
              child: Center(
                child: getIndexedWidget(context),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: kAppBackgroundColor,
              onTap: _onItemTapped,
              currentIndex: _selectedIndex,
              items: [
                BottomNavigationBarItem(
                  title: Text('Home'),
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  title: Text('Live'),
                  icon: ImageIcon(
                    AssetImage("assets/images/icon_live.png"),
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text('My Matches'),
                  icon: Icon(Icons.history),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
