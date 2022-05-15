import 'dart:io';

class ProfileEditModel {
  ProfileEditModel(
      {this.name,
      this.email,
      this.age = '18',
      this.gender = "Male",
      this.isLoading = false,
      this.profilePic});
  final File profilePic;
  final String name;
  final String email;
  final String age;
  final String gender;
  final bool isLoading;

  ProfileEditModel copyWith({
    File profilePic,
    String name,
    String email,
    String age,
    String gender,
    bool isLoading,
  }) {
    return ProfileEditModel(
        profilePic: profilePic ?? this.profilePic,
        name: name ?? this.name,
        email: email ?? this.email,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        isLoading: isLoading ?? this.isLoading);
  }
}
