import 'package:flutter/material.dart';
import 'dart:io' as Io;
import 'dart:convert';

class AppBarTitles {
  static final Text home = Text('Time Victor');
  static final Text login = Text('LOG IN');
  static final Text register = Text('Registrations');
  static final Text addDetails = Text('Personal Details');
  static final Text profile = Text('Profile');
  static final Text editProfile = Text('Edit Details');
}
const double kSingleStudentPoint = 9.1;
//528FF0
const String kPaymentKey = 'rzp_live_3Uo1rOZM7EhYeH';
const String kAppBackgoundColorCode = '#542368';
Color kAppBackgroundColor = Color(0xff542368);
const String kRupeeSymbol = '\u{20B9}';

const List<int> kColorCodes = [
  0xff542368,
  0xFF36102e,
  0xFF82192e,
  0xFFa3b548,
  0xFF16170f,
  0xFF27565e,
  0xFFff12e3,
  0xFFf70a90,
  0xFF20232a,
];
ShapeBorder kButtonShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));

ShapeBorder kCardShape(double radius) =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

const String kDefaultState = 'Select';
const List<String> kGenderList = ['Male', 'Female', 'other'];

const TextStyle kProfileTextStyle = TextStyle(
  fontSize: 20.0,
  color: Color(0xff542368),
  fontWeight: FontWeight.bold,
);

const TextStyle kSpotsTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

List<String> kGetAgeList() {
  List<String> list = [];
  for (int i = 18; i < 100; i++) {
    list.add('$i');
  }
  return list;
}

const List<String> kMonths = [
  'Jan',
  'Feb',
  'March',
  'April',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec'
];

const List<String> kCountryCodeList = ['+91', '+92', '+997'];

const String kTVLogoURL =
    'https://firebasestorage.googleapis.com/v0/b/timemarks-timevictor.appspot.com/o/tvLogoFinal.png?alt=media&token=f2bc385b-220e-4913-a361-7223121cacac';

String kGetLogoBase64String() {
  final bytes = Io.File('assets/images/tvLogoFinal.png').readAsBytesSync();

  return base64Encode(bytes);
}

String kTermsAndConditionsURL = 'https://www.timevictor.com/terms-conditions';
String kAppUpdateUrl = "https://www.timevictor.com/";
const List<String> kStatesList = [
  kDefaultState,
  'Andaman & Nicobar [AN]',
  'Andhra Pradesh [AP]',
  'Arunachal Pradesh [AR]',
  'Assam [AS]',
  'Bihar [BH]',
  'Chandigarh [CH]',
  'Chhattisgarh [CG]',
  'Dadra & Nagar Haveli [DN]',
  'Daman & Diu [DD]',
  'Delhi [DL]',
  'Goa [GO]',
  'Gujarat [GU]',
  'Haryana [HR]',
  'Himachal Pradesh [HP]',
  'Jammu & Kashmir [JK]',
  'Jharkhand [JH]',
  'Karnataka [KR]',
  'Kerala [KL]',
  'Lakshadweep [LD]',
  'Madhya Pradesh [MP]',
  'Maharashtra [MH]',
  'Manipur [MN]',
  'Meghalaya [ML]',
  'Mizoram [MM]',
  'Nagaland [NL]',
  'Orissa [OR]',
  'Pondicherry [PC]',
  'Punjab [PJ]',
  'Rajasthan [RJ]',
  'Sikkim [SK]',
  'Tamil Nadu [TN]',
  'Tripura [TR]',
  'Uttar Pradesh [UP]',
  'Uttaranchal [UT]',
  'West Bengal [WB]'
];
