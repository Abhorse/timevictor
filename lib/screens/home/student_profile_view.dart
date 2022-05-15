import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/modals/avg_tm_score.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/modals/timemarks_profile.dart';
import 'package:timevictor/screens/charts/bar_charts.dart';
import 'package:timevictor/screens/charts/consistency.dart';
import 'package:timevictor/screens/charts/line_chart.dart';
import 'package:timevictor/services/timemarks.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:timevictor/widgets/profile_pic_widget.dart';

class StudentProfile extends StatefulWidget {
  final Student student;

  StudentProfile({Key key, this.student}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  TimemarksProfile studentTMProfile = TimemarksProfile(
    name: '',
    recommendedSubject: '',
    timemarksPoints: 0,
  );
  bool isLoading = true;
  List<AvgTMScore> data = [];

  @override
  void initState() {
    print('calling student profile API');
    getTimemarksProfile();
    super.initState();
  }

  Future<void> getTimemarksProfile() async {
    try {
      var studentData =
          await TimeMarksAPIs.getStudentProfileData(widget.student.id);

      TimemarksProfile timemarksProfile = TimemarksProfile.fromMap(studentData);
      studentTMProfile = timemarksProfile;
      data = timemarksProfile.performanceData;
      studentChartData = timemarksProfile.consistencyData;
    } catch (e) {
      print(e);
      PlatformAlertDialog(
        title: 'Error',
        content:
            'An error occuerd while fetching timemarks profile data of the student. Please try again.',
        defaultActionText: 'OK',
      ).show(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<StudentConsistency> studentChartData = [];

  Widget profileCard(BuildContext context) {
    return Container(
      // height: 300.0,
      width: MediaQuery.of(context).size.width,
      height: 220.0,
      margin: EdgeInsets.all(10.0),
      // color: Colors.red,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 15.0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 160,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffe05e63),
                    width: 3.0,
                  )),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentTMProfile.name,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.grey[600]),
                    ),
                    Text(
                        'Expertise in: ${studentTMProfile.recommendedSubject}'),
                    Text(
                      'Score Points: ${studentTMProfile.timemarksPoints}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    TabBar(
                      indicatorColor: kAppBackgroundColor,
                      indicatorWeight: 5,
                      labelColor: kAppBackgroundColor,
                      unselectedLabelColor: Colors.black38,
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(child: Text('Performance')),
                        Tab(child: Text('Details')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 50.0,
            child: Container(
              // width: 120,
              // height: 130,
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
                      profilePicURL: widget.student.profilePic,
                      radius: 40.0,
                      heroTag: widget.student.id,
                    ),
                    // student.profilePic != null
                    //     ? FadeInImage.assetNetwork(
                    //         height: 130.0,
                    //         width: 120.0,
                    //         placeholder: 'assets/images/Loading-Image.gif',
                    //         // placeholder: 'assets/images/circularLoader.gif',
                    //         image: student.profilePic,
                    //         fit: BoxFit.cover,
                    //       )
                    //     : Image(
                    //         height: 130.0,
                    //         width: 120.0,
                    //         image: AssetImage('assets/images/studentProfile.png'),
                    //         fit: BoxFit.cover,
                    //       ),

                    // child: Icon(Icons.person, size: 100.0,),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 35.0,
            top: 50.0,
            child: Container(
              child: Tooltip(
                preferBelow: false,
                showDuration: Duration(seconds: 2),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                margin: EdgeInsets.symmetric(horizontal: 100.0),
                excludeFromSemantics: false,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(
                  Icons.info,
                  color: kAppBackgroundColor,
                ),
                textStyle: TextStyle(color: Colors.black),
                message: studentTMProfile.about ??
                    'Student has not added his/her description.',
                // 'Hi, It\'s ${widget.student.name}, 3rd year B.SC studnet, I\'m doing my prepartion for SSC exam.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView performanceCharts(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ExpansionTile(
            title: Text(
              'Consistency Chart',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 400.0,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CustomLineChat(
                        data: studentChartData,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'Speed –knowledge Chart',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 350.0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: BarCharts(
                        data: data,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowKeyValuePair(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget rowKeyValuePairAcademics(String key, bool isBoard, String board,
      double percentage, bool isVerified) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            isVerified
                ? Icon(
                    Icons.verified_user,
                    color: Colors.green,
                  )
                : Text(
                    'Not Verified',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )
          ],
        ),
        Divider(
          thickness: 1.0,
          color: kAppBackgroundColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isBoard ? 'Board' : 'University',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              board ?? 'NA',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Percentage',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              percentage != null ? percentage.toString() : 'NA',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        )
      ],
    );
  }

  ListView studentSummary(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ExpansionTile(
            title: Text(
              'Summary',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            children: [
              SizedBox(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      rowKeyValuePair('Total Quiz Attempted',
                          studentTMProfile.attemptedQuizCount.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'Academics',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            children: [
              SizedBox(
                height: 300.0,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      rowKeyValuePairAcademics(
                        '10th',
                        true,
                        studentTMProfile.tenthBoard,
                        studentTMProfile.tenthPercentage,
                        studentTMProfile.isTenthVerified ?? false,
                      ),
                      rowKeyValuePairAcademics(
                        '12th',
                        true,
                        studentTMProfile.twelfthBoard,
                        studentTMProfile.twelfthPercentage,
                        studentTMProfile.istwelfthVerified ?? false,
                      ),
                      rowKeyValuePairAcademics(
                        'Graduation',
                        false,
                        studentTMProfile.graduationBoard,
                        studentTMProfile.graduationPercentage,
                        studentTMProfile.isgraduationVerified ?? false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('building ${widget.student.name}\'s profile');
    return WillPopScope(
      onWillPop: () {
        // Navigator.pop(context);
        return new Future(() => false);
      },
      child: Container(
        color: kAppBackgroundColor,
        child: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              body: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [kAppBackgroundColor, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.5, 0.5]),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Center(
                                child: Text(
                                  'TIMEMARKS PROFILE',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: IconButton(
                                icon: Icon(
                                  Icons.autorenew,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Navigator.pop(context);
                                  build(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        profileCard(context),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: TabBarView(
                              children: [
                                performanceCharts(context),
                                studentSummary(context),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
