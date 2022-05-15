import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/bLoCs/edit_profile_bloc.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/data/shared_preferences.dart';
import 'package:timevictor/modals/profile_edit.dart';
import 'package:timevictor/modals/user_info.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/image_picker_widget.dart';
import 'package:timevictor/widgets/platform_dropdown.dart';
import 'package:timevictor/widgets/platform_exception_alert_dialog.dart';

import '../../constants.dart';

class EditProfileBlocBased extends StatefulWidget {
  const EditProfileBlocBased({@required this.bloc, @required this.userData});
  final EditProfileBloc bloc;
  final UserInfo userData;

  static Widget create(BuildContext context) {
    final database =
        FirestoreDatabase(uid: Provider.of<Data>(context, listen: false).uid);
    return Provider<EditProfileBloc>(
      create: (context) => EditProfileBloc(database: database),
      child: Consumer<EditProfileBloc>(
        builder: (context, bloc, _) => EditProfileBlocBased(
          userData: Provider.of<Data>(context, listen: false).user,
          bloc: bloc,
        ),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EditProfileBlocBasedState createState() => _EditProfileBlocBasedState();
}

class _EditProfileBlocBasedState extends State<EditProfileBlocBased> {
  Future<void> onFormSubmit(
      BuildContext context, ProfileEditModel model) async {
    UserInfo userInfo = UserInfo(
      name: model.name ?? widget.userData.name,
      email: model.email ?? widget.userData.email,
      age: model.age ?? widget.userData.age,
      gender: model.gender ?? widget.userData.gender,
    );
    try {
      UserInfo userInfoResponse = await widget.bloc.onFormSubmit(userInfo);
      SharedPref sharedPref = SharedPref();
      await sharedPref.saveUserInfo(userInfoResponse);
      Provider.of<Data>(context, listen: false)
          .updateUserInfo(await sharedPref.getUserInfo());
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation Failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileEditModel>(
      stream: widget.bloc.modelStream,
      initialData: ProfileEditModel(
        name: widget.userData.name,
        email: widget.userData.email,
        gender: widget.userData.gender,
        age: widget.userData.age,
      ),
      builder: (context, snapshot) {
        final ProfileEditModel model = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitles.editProfile,
            backgroundColor: kAppBackgroundColor,
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.white,
                ),
                onPressed: () => onFormSubmit(context, model),
              )
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: model.isLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        ImagePickerWidget(
                          image: model.profilePic,
                          getImage: widget.bloc.getImage,
                          priImageURL: widget.userData.profilePicURL,
                        ),
                        TextFormField(
                          initialValue: model.name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(labelText: 'Name'),
                          onChanged: (value) {
                            widget.bloc.updateWith(name: value);
                          },
                        ),
                        TextFormField(
                          initialValue: model.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: 'Email'),
                          onChanged: (value) {
                            widget.bloc.updateWith(email: value);
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              'Your Age',
                              style: TextStyle(fontSize: 15.0),
                            )),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: PlatformDropdown(
                                    items: kGetAgeList(),
                                    defaultItem: model.age,
                                    onchange: (age) {
                                      widget.bloc.updateWith(age: age);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              'Gender',
                              style: TextStyle(fontSize: 15.0),
                            )),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: PlatformDropdown(
                                    items: kGenderList,
                                    defaultItem: model.gender,
                                    onchange: (gender) {
                                      widget.bloc.updateWith(gender: gender);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
