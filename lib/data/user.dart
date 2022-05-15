import 'package:flutter/material.dart';

class User {
  User({@required this.uid, this.isNewUser});
  final String uid;
  final bool isNewUser;
}