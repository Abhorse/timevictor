import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timevictor/modals/profile_edit.dart';
import 'package:timevictor/modals/user_info.dart';
import 'package:timevictor/services/database.dart';

class EditProfileBloc {
  EditProfileBloc({@required this.database});
  final Database database;
  final StreamController<ProfileEditModel> _modelController =
      StreamController();

  Stream<ProfileEditModel> get modelStream => _modelController.stream;
  ProfileEditModel _model = ProfileEditModel();
  void dispose() {
    _modelController.close();
  }

  Future<UserInfo> onFormSubmit(UserInfo userInfo) async {
    updateWith(isLoading: true);
    try {
      if (_model.profilePic != null) {
        var url = await database.uploadImage(_model.profilePic);
        UserInfo userInfoUpdated = UserInfo(
          age: userInfo.age,
          name: userInfo.name,
          gender: userInfo.gender,
          email: userInfo.email,
          profilePicURL: url,
        );
        await database.updateUserInfo(userInfoUpdated);
        return userInfoUpdated;
      } else {
        await database.updateUserInfo(userInfo);
        return userInfo;
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> getImage() async {
    var image = (await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 500.0,
      maxWidth: 400.0,
    ));
    if (image != null) {
      updateWith(profilePic: File(image.path));
    }
  }

  void updateWith({
    File profilePic,
    String name,
    String email,
    String age,
    String gender,
    bool isLoading,
  }) {
    _model = _model.copyWith(
        profilePic: profilePic,
        name: name,
        email: email,
        age: age,
        gender: gender,
        isLoading: isLoading);

    _modelController.add(_model);
  }
}
