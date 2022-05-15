import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart' show CombineLatestStream;
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/modals/subject.dart';
import 'package:timevictor/screens/home/review_team.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/circular_loader.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:timevictor/widgets/student_tile.dart';

class CreateTeamView extends StatefulWidget {
  const CreateTeamView(
      {Key key,
      this.subjects,
      this.matchID,
      this.teamAName,
      this.teamBName,
      this.maxTeamStudents})
      : super(key: key);
  final List<Subject> subjects;
  final String matchID;
  final String teamAName;
  final String teamBName;
  final int maxTeamStudents;

  @override
  _CreateTeamViewState createState() => _CreateTeamViewState();
}

class _CreateTeamViewState extends State<CreateTeamView> {
  // List<Student> studentList = [];
  int currentPoints = 0;
  List<Student> selectedStudentList = [];

  void isTeamCompleted() {
    print(Provider.of<Data>(context, listen: false).subjectsList.length);
    if (Provider.of<Data>(context, listen: false).selectedStudentList.length ==
        widget.maxTeamStudents) {
      print('Team Competed');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewTeam(
            matchID: widget.matchID,
          ),
        ),
      );
      return;
    }
    PlatformAlertDialog(
      title: 'In-complete Team',
      content:
          'Currently you have ${Provider.of<Data>(context, listen: false).selectedStudentList.length} students in your team, Please select ${widget.maxTeamStudents} students',
      defaultActionText: 'OK',
    ).show(context);
  }

  bool validateSubjects(Student student) {
    var data = Provider.of<Data>(context, listen: false);
    int sws = 0;
    data.selectedStudentList.forEach((s) {
      if (s.subject == student.subject) {
        sws += 1;
      }
    });
    var sub =
        widget.subjects.firstWhere((sub) => sub.subject == student.subject);
    if ((sws > sub.maxStudents - 1)) {
      return false;
    }
    return true;
  }

  void selectStudent(Student student) {
    var providerData = Provider.of<Data>(context, listen: false);
    if (student == null) {
      PlatformAlertDialog(
        title: 'Error 404',
        content: 'Please referesh the page',
        defaultActionText: 'OK',
      ).show(context);
      return;
    }
    int sws = 0;
    providerData.selectedStudentList.forEach((s) {
      if (s.subject == student.subject) {
        sws += 1;
      }
    });
    var sub =
        widget.subjects.firstWhere((sub) => sub.subject == student.subject);
    if ((sws > sub.maxStudents - 1)) {
      PlatformAlertDialog(
        title: 'Error',
        content:
            'You can selected minimum ${sub.minStudents} and maximun ${sub.maxStudents} students in ${sub.subject} , Please select students from other subjects',
        defaultActionText: 'OK',
      ).show(context);
      return;
    }
    if (providerData.selectedStudentList.length == widget.maxTeamStudents) {
      PlatformAlertDialog(
        title: 'You are Done',
        content:
            'You have selected ${providerData.selectedStudentList.length}/${widget.maxTeamStudents} students in your team, Please click on Done Button',
        defaultActionText: 'OK',
      ).show(context);
      return;
    }
    print(providerData.selectedStudentList.contains(student));
    if (!providerData.selectedStudentList.contains(student)) {
      providerData.selectStudentToTeam(student);
      print('added');
    } else {
      providerData.removeStudentToTeam(student);
      print('removed');
    }
    print(providerData.selectedStudentList.contains(student));

    // setState(() {
    //   selectedStudentList.add(student);
    //   currentPoints += int.parse(student.points);
    // });
  }

  List<Tab> tabList() {
    return widget.subjects
        .map((e) => Tab(
              text: e.subject,
            ))
        .toList();
  }

  List<Widget> getStudentList(
      List<Student> teamAStudents, List<Student> teamBStudents) {
    teamAStudents.sort((a, b) => a.points.compareTo(b.points));
    var sortedTeamA = teamAStudents.reversed;
    teamBStudents.sort((a, b) => a.points.compareTo(b.points));
    var sortedTeamB = teamBStudents.reversed;

    List<Widget> list = [];
    sortedTeamA.forEach((student) {
      list.add(StudentTile(
        student: student,
        teamName: widget.teamAName,
        // selectStudent: (data) => validateSubjects(data),
        subjects: widget.subjects,
        maxTeamStudents: widget.maxTeamStudents,
        // selectedStudentList: selectedStudentList,
        // currentPoints: currentPoints,
      ));
    });
    sortedTeamB.forEach((student) {
      list.add(StudentTile(
        student: student,
        teamName: widget.teamBName,
        maxTeamStudents: widget.maxTeamStudents,
      ));
    });
    return list;
  }

  List<Widget> tabBarView(
      List<Student> teamAStudents, List<Student> teamBStudents) {
    List<Widget> list = [];
    TextStyle fontStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15.0,
      color: Colors.grey,
      fontStyle: FontStyle.italic,
    );
    widget.subjects.forEach((subject) {
      list.add(Column(
        children: [
          Expanded(
            child: ListView(
              children: getStudentList(
                  teamAStudents
                      .where((student) => student.subject == subject.subject)
                      .toList(),
                  teamBStudents
                      .where((student) => student.subject == subject.subject)
                      .toList()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You can select',
                      style: fontStyle,
                    ),
                    Text(
                      'Minimun ${subject.minStudents ?? 0} students',
                      style: fontStyle,
                    ),
                    Text(
                      'Maximun ${subject.maxStudents ?? 'All'} students',
                      style: fontStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ));
    });
    return list;
  }

  void removeStudentsAndSubjects() {
    Provider.of<Data>(context, listen: false).removeAllStudentsFromList();
    Provider.of<Data>(context, listen: false).removeSubjectsFromList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print('create team re-building');
    Database database =
        FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
    // return Consumer<Data>(
    //   builder: (context, proData, _) {
    //     return  DefaultTabController(
    //   length: widget.subjects.length,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: kAppBackgroundColor,
    //       leading: IconButton(
    //         icon: Icon(Icons.arrow_back),
    //         onPressed: () {
    //           removeStudentsAndSubjects();
    //           Navigator.pop(context);
    //         },
    //       ),
    //       title: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text('Create Your Team'),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 'Points Used: ${proData.currentTotalPoints}/100',
    //                 style: TextStyle(
    //                   fontSize: 15.0,
    //                   color: Colors.grey,
    //                 ),
    //               ),
    //               Text(
    //                 'Student Selected: ${proData.selectedStudentList.length}/11',
    //                 style: TextStyle(
    //                   fontSize: 15.0,
    //                   color: Colors.grey,
    //                 ),
    //               )
    //             ],
    //           ),
    //         ],
    //       ),
    //       bottom: TabBar(
    //         indicatorColor: Colors.white,
    //         tabs: tabList(),
    //       ),
    //     ),
    //     floatingActionButton: FloatingActionButton.extended(
    //       label: Text('Done'),
    //       backgroundColor: kAppBackgroundColor,
    //       onPressed: isTeamCompleted,
    //     ),
    //     body: StreamBuilder(
    //       stream: CombineLatestStream.list([
    //         database.getTeamAStudents(widget.matchID),
    //         database.getTeamBStudents(widget.matchID)
    //       ]),
    //       builder: (context, snapshots) {
    //         if (snapshots.connectionState == ConnectionState.active) {
    //           // List<Student> list = snapshots.data[0] + snapshots.data[1];
    //           return TabBarView(
    //             children: tabBarView(snapshots.data[0], snapshots.data[1]),
    //           );
    //         } else
    //           return Center(
    //             child: CircularProgressIndicator(),
    //           );
    //       },
    //     ),
    //   ),
    // );
    //   },
    // );
    return WillPopScope(
      onWillPop: () {
        removeStudentsAndSubjects();
        return new Future(() => false);
      },
      child: DefaultTabController(
        length: widget.subjects.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kAppBackgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: removeStudentsAndSubjects,
            ),
            title: CreateTeamHeader(
              maxTeamStudents: widget.maxTeamStudents,
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: tabList(),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text('Done'),
            backgroundColor: kAppBackgroundColor,
            onPressed: isTeamCompleted,
          ),
          body: StreamBuilder(
            stream: CombineLatestStream.list([
              database.getTeamAStudents(widget.matchID),
              database.getTeamBStudents(widget.matchID)
            ]),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.active) {
                // List<Student> list = snapshots.data[0] + snapshots.data[1];
                return TabBarView(
                  children: tabBarView(snapshots.data[0], snapshots.data[1]),
                );
              } else
                return CircularLoader();
            },
          ),
        ),
      ),
    );
  }
}

class CreateTeamHeader extends StatelessWidget {
  const CreateTeamHeader({
    this.maxTeamStudents,
  });
  final int maxTeamStudents;
  int maxPoints() {
    return (maxTeamStudents * kSingleStudentPoint).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create Your Team'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Points Used: ${Provider.of<Data>(context).currentTotalPoints}/${maxPoints()}',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
              ),
            ),
            Text(
              'Student Selected: ${Provider.of<Data>(context).selectedStudentList.length}/$maxTeamStudents',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ],
    );
  }
}
