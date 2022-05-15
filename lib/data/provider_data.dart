import 'package:flutter/cupertino.dart';
import 'package:timevictor/modals/student.dart';
import 'package:timevictor/modals/subject.dart';
import 'package:timevictor/modals/user_info.dart';

class Data extends ChangeNotifier {
  String uid = '';
  String appVersion = '0';
  bool isLogged = false;
  String userPhoneNumber = 'NA';
  UserInfo user = UserInfo(
    name: 'NA',
    email: 'NA',
    age: 'NA',
    gender: 'NA',
    profilePicURL: '',
  );
  bool isOTPSending = false;
  String matchStatus = '';

  List<Student> selectedStudentList = [];
  double currentTotalPoints = 0;
  List<Subject> subjectsList = [];
  // List<SelectedTeam> selectedTeams = [];
  bool isSelectedTeamsAdded = false;

  void updateMatchStatus(String status) {
    matchStatus = status;
    notifyListeners();
  }

  void updateAppVerion(currentVerion) {
    appVersion = currentVerion;
    notifyListeners();
  }
  // void setSelectedTeams(List<SelectedTeam> teams) {
  //   if (teams != null && !isSelectedTeamsAdded) {
  //     teams.forEach((team) {
  //       selectedTeams.add(team);
  //     });
  //     print('set team list');
  //     isSelectedTeamsAdded = true;
  //   }
  //   // notifyListeners();
  // }

  // void removeSelectedTeamsFromList() {
  //   selectedTeams.clear();
  //   isSelectedTeamsAdded = false;
  //   print('cleared team list');
  // }

  void selectStudentToTeam(Student student) {
    selectedStudentList.add(student);
    currentTotalPoints += double.parse(student.points);
    notifyListeners();
  }

  void removeStudentToTeam(Student student) {
    selectedStudentList.removeWhere((element) => element.id == student.id);
    currentTotalPoints -= double.parse(student.points);
    notifyListeners();
  }

  void addSubjectToList(Subject subject) {
    subjectsList.add(subject);
    // notifyListeners();
  }

  void removeSubjectsFromList() {
    subjectsList.clear();
  }

  void removeAllStudentsFromList() {
    selectedStudentList.clear();
    currentTotalPoints = 0;
  }

  void otpLoadingToggle(bool isLoading) {
    isOTPSending = isLoading;
    notifyListeners();
  }

  void updatePhoneNumber(String verifiedNumber) {
    userPhoneNumber = verifiedNumber;
    notifyListeners();
  }

  void updateUID(String usersUID) {
    uid = usersUID;
    notifyListeners();
  }

  void loggedUser(bool status) {
    isLogged = status;
    notifyListeners();
  }

  void updateUserInfo(UserInfo userInfo) {
    user = userInfo;
    notifyListeners();
  }
}
