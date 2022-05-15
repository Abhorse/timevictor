import 'package:flutter/cupertino.dart';

class UserInfo {
  final String name;
  final String email;
  final String age;
  final String gender;
  final String profilePicURL;
  final List<String> joinedMatches;
  final int walletBalance;

  UserInfo({
    @required this.name,
    @required this.email,
    @required this.age,
    @required this.gender,
    this.profilePicURL,
    this.joinedMatches,
    this.walletBalance,
  });

  factory UserInfo.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String email = data['email'];
    final String age = data['age'];
    final String gender = data['gender'];
    final int walletBalance = data['walletBalance'] ?? 0;
    final String profilePicURL = data['profilePicURL'] ?? '';

    return UserInfo(
      name: name,
      email: email,
      age: age,
      gender: gender,
      walletBalance: walletBalance,
      profilePicURL: profilePicURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'profilePicURL': profilePicURL,
      'joinedMatches': joinedMatches,
      "walletBalance": walletBalance,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'profilePicURL': profilePicURL,
    };
  }
}
