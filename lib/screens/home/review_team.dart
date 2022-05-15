import 'dart:math';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/selected_team.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/utils/common_icons.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';

class ReviewTeam extends StatefulWidget {
  const ReviewTeam({@required this.matchID});

  final String matchID;

  @override
  _ReviewTeamState createState() => _ReviewTeamState();
}

class _ReviewTeamState extends State<ReviewTeam> {
  bool isCaptainSelected = false;
  bool isViceCaptainSelected = false;
  bool isThiredStudentSelected = false;

  Student captain;
  Student viceCaptain;
  Student thiredStudent;

  bool isLoading = false;

  String teamName;

  bool isCaptain(Student student) {
    if (captain != null) {
      return student.id == captain.id;
    }
    return false;
  }

  bool isViceCaptain(Student student) {
    if (viceCaptain != null) {
      return student.id == viceCaptain.id;
    }
    return false;
  }

  bool isThiredStudent(Student student) {
    if (thiredStudent != null) {
      return student.id == thiredStudent.id;
    }
    return false;
  }

  void setStudent(Student student, String position) {
    if (position == 'captain') {
      setState(() {
        captain = student;
      });
    } else if (position == 'viceCaptain') {
      setState(() {
        viceCaptain = student;
      });
    } else {
      setState(() {
        thiredStudent = student;
      });
    }
  }

  void showAlertBox(String position) {
    PlatformAlertDialog(
      title: 'Already Selected',
      content: 'This Student is already selected as $position',
      defaultActionText: 'Ok',
    ).show(context);
  }

  void selectStudent(Student student, String position) {
    String superCaptainText = 'Super-Captain';
    String captainText = 'Captain';
    String viceCapatinText = 'Vice-Captain';
    if (captain == null && viceCaptain == null && thiredStudent == null) {
      setStudent(student, position);
    } else {
      if (position == 'captain') {
        if (captain != null && captain.id == student.id) {
          // showAlertBox(position);
          showAlertBox(superCaptainText);
        } else {
          if (viceCaptain == null && thiredStudent == null) {
            setStudent(student, position);
          } else if (viceCaptain != null && thiredStudent != null) {
            (viceCaptain.id == student.id || thiredStudent.id == student.id)
                ? showAlertBox(viceCaptain.id == student.id
                    ? captainText
                    : viceCapatinText)
                : setStudent(student, position);
          } else if (viceCaptain != null) {
            viceCaptain.id == student.id
                ? showAlertBox(captainText)
                : setStudent(student, position);
          } else {
            thiredStudent.id == student.id
                ? showAlertBox(viceCapatinText)
                : setStudent(student, position);
          }
        }
      } else if (position == 'viceCaptain') {
        if (viceCaptain != null && viceCaptain.id == student.id) {
          // showAlertBox(position);
          showAlertBox(captainText);
        } else {
          if (captain == null && thiredStudent == null) {
            setStudent(student, position);
          } else if (captain != null && thiredStudent != null) {
            (captain.id == student.id || thiredStudent.id == student.id)
                ? showAlertBox(captain.id == student.id
                    ? superCaptainText
                    : viceCapatinText)
                : setStudent(student, position);
          } else if (captain != null) {
            captain.id == student.id
                ? showAlertBox(superCaptainText)
                : setStudent(student, position);
          } else {
            thiredStudent.id == student.id
                ? showAlertBox(viceCapatinText)
                : setStudent(student, position);
          }
        }
      } else {
        if (thiredStudent != null && thiredStudent.id == student.id) {
          showAlertBox(viceCapatinText);
          // showAlertBox(position);
        } else {
          if (viceCaptain == null && captain == null) {
            setStudent(student, position);
          } else if (viceCaptain != null && captain != null) {
            (viceCaptain.id == student.id || captain.id == student.id)
                ? showAlertBox(
                    captain.id == student.id ? superCaptainText : captainText)
                : setStudent(student, position);
          } else if (viceCaptain != null) {
            viceCaptain.id == student.id
                ? showAlertBox(captainText)
                : setStudent(student, position);
          } else {
            captain.id == student.id
                ? showAlertBox(superCaptainText)
                : setStudent(student, position);
          }
        }
      }
    }
  }

  Widget studentCard(Student student) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  Text(
                    student.name,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text('Points'),
                      SizedBox(height: 5.0),
                      Text(student.points),
                    ],
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  ClipOval(
                    child: Material(
                      color: kAppBackgroundColor, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CommonIcons.superCaptainIcon(
                            color: isCaptain(student)
                                ? Colors.yellow
                                : Colors.white,
                          ),
                        ),
                        onTap: () => selectStudent(student, 'captain'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  ClipOval(
                    child: Material(
                      color: kAppBackgroundColor, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CommonIcons.captainIcon(
                            color: isViceCaptain(student)
                                ? Colors.yellow
                                : Colors.white,
                          ),
                        ),
                        onTap: () => selectStudent(student, 'viceCaptain'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  ClipOval(
                    child: Material(
                      color: kAppBackgroundColor, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CommonIcons.viceCaptainIcon(
                            color: isThiredStudent(student)
                                ? Colors.yellow
                                : Colors.white,
                          ),
                        ),
                        onTap: () => selectStudent(student, 'thirdStudent'),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getAllStudents(BuildContext context, String subject) {
    List<Widget> list = [];
    Provider.of<Data>(context)
        .selectedStudentList
        .sort((a, b) => a.points.compareTo(b.points));
    Provider.of<Data>(context)
        .selectedStudentList
        .where((stu) => stu.subject == subject)
        .forEach((student) {
      list.add(studentCard(student));
    });
    return list;
  }

  List<Widget> subjectWiseView(BuildContext context) {
    List<Widget> list = [];
    Provider.of<Data>(context).subjectsList.forEach((subject) {
      list.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            subject.subject,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          children: getAllStudents(context, subject.subject),
        ),
      ));
    });

    return list;
  }

  Future<void> saveTeamInDataBase() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    List<String> studentsId = [];
    Provider.of<Data>(context, listen: false)
        .selectedStudentList
        .forEach((student) {
      studentsId.add(student.id);
    });
    SelectedTeam selectedTeam = SelectedTeam(
        teamName: teamName,
        studentsId: studentsId,
        captainId: captain.id,
        viceCaptainId: viceCaptain.id,
        thirdBestId: thiredStudent.id);
    try {
      Database database =
          FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
      await database.createTeam(selectedTeam, widget.matchID);
      setState(() {
        isLoading = false;
      });
      Provider.of<Data>(context, listen: false).removeAllStudentsFromList();
      Provider.of<Data>(context, listen: false).removeSubjectsFromList();
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: (captain == null ||
                  viceCaptain == null ||
                  thiredStudent == null ||
                  teamName == null ||
                  teamName.isEmpty || isLoading)
              ? null
              : FloatingActionButton.extended(
                  onPressed: () {
                    print('Done');
                    saveTeamInDataBase();
                  },
                  backgroundColor: Colors.green,
                  label: Text('Save'),
                ),
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Column(
              children: [
                Container(
                  color: kAppBackgroundColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon:
                                Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            'Choose Top Three Students',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      getIconLabelPair(
                        CommonIcons.superCaptainIcon(color: Colors.yellow),
                        'Super-Captain (3x)',
                      ),
                      getIconLabelPair(
                        CommonIcons.captainIcon(color: Colors.yellow),
                        'Captain (2x)',
                      ),
                      getIconLabelPair(
                        CommonIcons.viceCaptainIcon(color: Colors.yellow),
                        'Vice-Captain (1.5x)',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    cursorColor: kAppBackgroundColor,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: 'Enter Team Name',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        teamName = val;
                                      });
                                    },
                                  ),
                                ),
                                // SizedBox(
                                //   width: 100.0,
                                // )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: subjectWiseView(context),
                  ),
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         keyboardType: TextInputType.text,
                //         decoration: InputDecoration(labelText: 'Team Name'),
                //         onChanged: (val) {
                //           setState(() {
                //             teamName = val;
                //           });
                //         },
                //       ),
                //     ),
                //     SizedBox(
                //       width: 100.0,
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getIconLabelPair(Widget iconImage, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SizedBox(
        height: 30.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconImage,
            Text(
              '------>',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
