import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/circular_loader.dart';
import 'package:timevictor/widgets/profile_pic_widget.dart';

class StudentScoreboard extends StatelessWidget {
  final String matchId;
  final String teamAName;
  final String teamBName;

  StudentScoreboard({
    this.matchId,
    this.teamAName,
    this.teamBName,
  });

  List<Widget> getStudentScoreCardList(List<Student> students, bool isTeamA) {
    List<Widget> studentCardList = [];
    dynamic totalTeamScore = 0;
    students.forEach((student) {
      totalTeamScore += student.quizMarks;
      studentCardList.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ProfilePicWidget(
                      profilePicURL: student.profilePic,
                      heroTag: 'stu-${student.id}',
                      radius: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      student.name,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Quiz Score',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      student.quizMarks.toString(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ));
    });
    studentCardList.insert(
        0,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Team Score : $totalTeamScore',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ));

    return studentCardList;
  }

  Widget getTeamStudentList(BuildContext context, bool isTeamA) {
    String uid = Provider.of<Data>(context, listen: false).uid;
    Stream _stream = isTeamA
        ? FirestoreDatabase(uid: uid).getTeamAStudents(matchId)
        : FirestoreDatabase(uid: uid).getTeamBStudents(matchId);
    return StreamBuilder<List<Student>>(
      stream: _stream,
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.active) {
          List<Student> students = snapshots.data;
          if (students != null && students.length != 0) {
            return ListView(
              children: getStudentScoreCardList(students, isTeamA),
            );
          } else {
            return Center(
              child: Text('Not able to fetch students data'),
            );
          }
        } else {
          return CircularLoader();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Score Board'),
          backgroundColor: kAppBackgroundColor,
          bottom: TabBar(
            indicatorColor: Colors.red,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Tab>[
              Tab(
                child: Text(
                  teamAName,
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Tab(
                child: Text(
                  teamBName,
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            children: [
              getTeamStudentList(context, true),
              getTeamStudentList(context, false),
            ],
          ),
        ),
      ),
    );
  }
}
