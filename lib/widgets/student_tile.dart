import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/modals/subject.dart';
import 'package:timevictor/modals/validation.dart';
import 'package:timevictor/screens/home/student_profile_view.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:timevictor/widgets/profile_pic_widget.dart';

class StudentTile extends StatefulWidget {
  const StudentTile({
    Key key,
    @required this.student,
    @required this.teamName,
    this.maxTeamStudents,
    // this.selectStudent,
    this.subjects,
    // this.selectedStudentList,
    // this.currentPoints,
  }) : super(key: key);

  final Student student;
  final String teamName;
  final int maxTeamStudents;

  // final Function selectStudent;
  final List<Subject> subjects;

  // final List<Student> selectedStudentList;
  // final int currentPoints;

  @override
  _StudentTileState createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  bool isSelected = false;

  ValidateModel validateLimits() {
    var data = Provider.of<Data>(context, listen: false);
    if (data.selectedStudentList.length == widget.maxTeamStudents) {
      return ValidateModel(
        isValid: false,
        title: 'Invalid Chooise',
        content:
            'You have selected maximun ${widget.maxTeamStudents} students, Please click on Done button',
      );
    }

    int sws = 0;
    data.selectedStudentList.forEach((s) {
      if (s.subject == widget.student.subject) {
        sws += 1;
      }
    });
    var sub = data.subjectsList
        .firstWhere((sub) => sub.subject == widget.student.subject);
    if ((sws >= sub.maxStudents)) {
      var validateModel = ValidateModel(
        isValid: false,
        title: 'Invalid Chooise',
        content:
            'You can select minimun ${sub.minStudents} and maximun ${sub.maxStudents} students in ${sub.subject}. Please select student from other subjects',
      );
      return validateModel;
    }

    int needMinStudents = 0;
    data.subjectsList.forEach((sub) {
      if (sub.subject != widget.student.subject) {
        int stuCount = 0;
        data.selectedStudentList.forEach((s) {
          if (s.subject == sub.subject) {
            stuCount += 1;
          }
        });

        if (stuCount < sub.minStudents) {
          needMinStudents += (sub.minStudents - stuCount);
        }
      }
    });

    if (data.selectedStudentList.length + needMinStudents + 1 >
        widget.maxTeamStudents) {
      return ValidateModel(
        isValid: false,
        title: 'Invalid Chooise',
        content: 'You need to select students from other subjects as well',
      );
    }

    int maxPoints = (widget.maxTeamStudents * kSingleStudentPoint).toInt();
    if (data.currentTotalPoints + double.parse(widget.student.points) >
        maxPoints) {
      return ValidateModel(
        isValid: false,
        title: 'Invalid Chooise',
        content:
            'You can use maximum $maxPoints points, please select different set of students',
      );
    }
    return ValidateModel(
      isValid: true,
    );
  }

  bool isStudentSelected() {
    bool iscontainStudent = false;
    Provider.of<Data>(context, listen: false)
        .selectedStudentList
        .forEach((element) {
      if (element.id == widget.student.id) {
        iscontainStudent = true;
      }
    });

    return iscontainStudent;
  }

  @override
  Widget build(BuildContext context) {
    print('student tile re-building');
    var providerData = Provider.of<Data>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentProfile(
                student: widget.student,
              ),
            ),
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ProfilePicWidget(
                      profilePicURL: widget.student.profilePic,
                      radius: 25.0,
                      heroTag: widget.student.id,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      '${widget.student.name.toUpperCase()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'S.P.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          widget.student.points,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      children: [
                        Text(
                          'Team',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          widget.teamName,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: isStudentSelected()
                              ? Colors.red
                              : kAppBackgroundColor, // button color
                          child: InkWell(
                            splashColor: Colors.white, // inkwell color
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                isStudentSelected() ? Icons.remove : Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              ValidateModel isValidSelection = validateLimits();
                              if (isStudentSelected()) {
                                providerData
                                    .removeStudentToTeam(widget.student);
                              } else if (isValidSelection.isValid) {
                                providerData
                                    .selectStudentToTeam(widget.student);
                              } else {
                                PlatformAlertDialog(
                                  title: isValidSelection.title,
                                  content: isValidSelection.content,
                                  defaultActionText: 'OK',
                                ).show(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
