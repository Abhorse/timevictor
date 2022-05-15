import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart' show CombineLatestStream;
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/pole.dart';
import 'package:timevictor/modals/selected_team.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/modals/subject.dart';
import 'package:timevictor/screens/home/create_team_view.dart';
import 'package:timevictor/screens/home/selected_team_view.dart';
import 'package:timevictor/screens/home/student_score_board_view.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/circular_loader.dart';
import 'package:timevictor/widgets/pole_card_widget.dart';

class MatchPolesView extends StatelessWidget {
  MatchPolesView({
    Key key,
    @required this.teamAName,
    @required this.teamBName,
    @required this.matchID,
    @required this.maxTeamStudents,
  }) : super(key: key);
  final String teamAName;
  final String teamBName;
  final String matchID;
  final int maxTeamStudents;

  bool showHideButton(BuildContext context) {
    String status = Provider.of<Data>(context).matchStatus;
    if (status == 'LIVE' || status == 'Closed') {
      return true;
    } else
      return false;
  }

  List<Widget> getPoleList(List<Pole> poles) {
    return poles
        .map((pole) => PoleCard(
              pole: pole,
              teamAName: teamAName,
              teamBName: teamBName,
              matchID: matchID,
            ))
        .toList();
  }

  void viewTeam(BuildContext context, SelectedTeam selectedTeam) {
    Database database =
        FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamBuilder<List<List<Student>>>(
          stream: CombineLatestStream.list([
            database.getTeamAStudents(matchID),
            database.getTeamBStudents(matchID)
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              List<Student> students = snapshot.data[0] + snapshot.data[1];
              return SelectedTeamView(
                students: students,
                selectedTeam: selectedTeam,
              );
            } else
              return CircularLoader();
          },
        ),
      ),
    );
  }

  Widget contestList(BuildContext context) {
    Database database =
        FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
    // return Icon(Icons.directions_car);
    return StreamBuilder<List<Pole>>(
      stream: database.getPolesByMatch(matchID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<Pole> poles = snapshot.data;

          if (poles != null && poles.length != 0) {
            return ListView(children: getPoleList(poles));
          } else
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mood_bad,
                    color: Colors.deepOrangeAccent,
                    size: 30,
                  ),
                  Text('Currently contest are not available.',
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            );
        } else
          return CircularLoader();
      },
    );
  }

  List<Widget> getTeamsCard(
      List<SelectedTeam> selectedTeam, BuildContext context) {
    return selectedTeam
        .map((team) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => viewTeam(context, team),
                child: Card(
                  shape: kButtonShape,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          team.teamName,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        FlatButton(
                          child: Icon(Icons.view_array,
                              color: kAppBackgroundColor),
                          onPressed: () {
                            print(team.studentsId);
                            viewTeam(context, team);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }

  Widget teamList(BuildContext context) {
    Database database =
        FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
    return StreamBuilder<List<SelectedTeam>>(
      stream: database.getSelectedTeamsOfMatch(matchID),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.active) {
          List<SelectedTeam> selectedTeams = snapshots.data;
          if (selectedTeams != null && selectedTeams.length != 0) {
            //  TODO: This will add functionality to change the selected team
            // Provider.of<Data>(context, listen: false)
            //     .setSelectedTeams(selectedTeams);
            return ListView(
              children: getTeamsCard(selectedTeams, context),
            );
          } else
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_neutral,
                  color: Colors.deepOrangeAccent,
                  size: 30.0,
                ),
                Text(
                  'You don\'t have any team yet, Please create one!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent,
                  ),
                )
              ],
            );
        } else
          return CircularLoader();
      },
    );
  }

  void createTeam(BuildContext context) {
    Database database =
        FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder<List<Subject>>(
            stream: database.getSubjects(matchID),
            builder: (context, snapshot) {
              List<Subject> subjects = snapshot.data;
              if (snapshot.connectionState == ConnectionState.active) {
                if (subjects != null) {
                  subjects.forEach((subject) {
                    Provider.of<Data>(context, listen: false)
                        .addSubjectToList(subject);
                  });
                }
                return CreateTeamView(
                  subjects: subjects,
                  matchID: matchID,
                  teamAName: teamAName,
                  teamBName: teamBName,
                  maxTeamStudents: maxTeamStudents,
                );
              } else
                return CircularLoader();
            },
          ),
        ));
  }

  void showScoreboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentScoreboard(
          matchId: matchID,
          teamAName: teamAName,
          teamBName: teamBName,
        ),
      ),
    );
  }

  void onPressBackButtons(BuildContext context) {
    Provider.of<Data>(context, listen: false).removeSubjectsFromList();
    // Provider.of<Data>(context, listen: false).removeSelectedTeamsFromList();
    Navigator.pop(context);
  }

  final ScrollController _scrollViewController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onPressBackButtons(context);
        return new Future(() => false);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text('$teamAName vs $teamBName'),
                  backgroundColor: kAppBackgroundColor,
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    indicatorColor: Colors.red,
                    indicatorWeight: 4,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: <Tab>[
                      Tab(
                        child: Text(
                          'CONTESTS',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'MY TEAMS',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              children: [
                // teamList(context),
                contestList(context),
                // Text('test'),
                teamList(context),
              ],
            ),
          ),
          floatingActionButton: showHideButton(context)
              ? FloatingActionButton.extended(
                  label: Text('SCORE BOARD'),
                  // icon: Icon(Icons.add),
                  onPressed: () => showScoreboard(context),
                  backgroundColor: kAppBackgroundColor,
                )
              : FloatingActionButton.extended(
                  label: Text('Create Team'),
                  icon: Icon(Icons.add),
                  onPressed: () => createTeam(context),
                  backgroundColor: kAppBackgroundColor,
                ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () {
  //       onPressBackButtons(context);
  //       return new Future(() => false);
  //     },
  //     child: DefaultTabController(
  //       length: 2,
  //       child: Scaffold(
  //         appBar: AppBar(
  //           title: Text('$teamAName vs $teamBName'),
  //           backgroundColor: kAppBackgroundColor,
  //           leading: IconButton(
  //             icon: Icon(Icons.arrow_back),
  //             onPressed: () => onPressBackButtons(context),
  //           ),
  //           bottom: TabBar(indicatorColor: Colors.white, tabs: <Tab>[
  //             Tab(
  //               child: Text(
  //                 'MY TEAM',
  //                 style: TextStyle(fontWeight: FontWeight.w900),
  //               ),
  //             ),
  //             Tab(
  //               child: Text(
  //                 'CONTESTS',
  //                 style: TextStyle(fontWeight: FontWeight.w900),
  //               ),
  //             ),
  //           ]),
  //         ),
  //         floatingActionButton: showHideButton(context)
  //             ? null
  //             : FloatingActionButton.extended(
  //                 label: Text('Create Team'),
  //                 icon: Icon(Icons.add),
  //                 onPressed: () => createTeam(context),
  //                 backgroundColor: kAppBackgroundColor,
  //               ),
  //         body: TabBarView(
  //           children: [
  //             teamList(context),
  //             contestList(context),
  //             // teamList(context),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
