// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/modals/selected_team.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/screens/home/student_profile_view.dart';
import 'package:timevictor/utils/common_icons.dart';
import 'package:timevictor/widgets/profile_pic_widget.dart';

class SelectedTeamView extends StatelessWidget {
  const SelectedTeamView({
    Key key,
    @required this.students,
    @required this.selectedTeam,
  }) : super(key: key);

  final List<Student> students;
  final SelectedTeam selectedTeam;

  List<Widget> getTeamExcludingCaptain(BuildContext context) {
    List<Widget> list = [];

    selectedTeam.studentsId.forEach((id) {
      if (selectedTeam.captainId != id &&
          selectedTeam.viceCaptainId != id &&
          selectedTeam.thirdBestId != id) {
        Student student = students.firstWhere((stu) => stu.id == id);
        list.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentProfile(
                      student: student,
                    ),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: ProfilePicWidget(
                              profilePicURL: student.profilePic,
                              radius: 25.0,
                              heroTag: student.id,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              student.points,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              student.name,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Text(
                            student.subject,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });

    return list;
  }

  Widget topStudentCard(
      BuildContext context, Student student, ImageIcon tagIcon) {
    return Container(
      // height: 300.0,
      width: 200.0,
      height: 100.0,
      margin: EdgeInsets.all(10.0),
      // color: Colors.red,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentProfile(
                student: student,
              ),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              bottom: 0.0,
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  border: Border.all(
                    color: kAppBackgroundColor,
                    width: 3.0,
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text('Experties in: ${student.subject}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Score Points: ${student.points}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          tagIcon,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.white60,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 6.0,
                      )
                    ]),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: ProfilePicWidget(
                        profilePicURL: student.profilePic,
                        radius: 40.0,
                        heroTag: student.id,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCaptain(BuildContext context) {
    Student student =
        students.firstWhere((stu) => stu.id == selectedTeam.captainId);
    Student viceCaptain =
        students.firstWhere((stu) => stu.id == selectedTeam.viceCaptainId);
    Student thirdBest =
        students.firstWhere((stu) => stu.id == selectedTeam.thirdBestId);

    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        topStudentCard(
          context,
          student,
          CommonIcons.superCaptainIcon(
            color: Color(0xffd4af37),
          ),
        ),
        topStudentCard(
          context,
          viceCaptain,
          CommonIcons.captainIcon(
            color: kAppBackgroundColor,
          ),
        ),
        topStudentCard(
          context,
          thirdBest,
          CommonIcons.viceCaptainIcon(
            color: Color(0xffcd7f32),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kAppBackgroundColor,
        title: Text(selectedTeam.teamName),
        actions: [
          FlatButton(
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Best 3 Selected Students',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200.0,
            child: getCaptain(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Divider(
              height: 5.0,
              color: kAppBackgroundColor,
              thickness: 1.5,
            ),
          ),
          Expanded(
            child: ListView(
              children: getTeamExcludingCaptain(context),
            ),
          ),
        ],
      ),
    );
  }
}
