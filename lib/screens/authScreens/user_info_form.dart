import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/data/shared_preferences.dart';
import 'package:timevictor/modals/user_info.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/services/dynamic_links_services.dart';
import 'package:timevictor/widgets/CircularButton.dart';
import 'package:timevictor/widgets/image_picker_widget.dart';
import 'package:timevictor/widgets/platform_dropdown.dart';
import 'package:timevictor/widgets/platform_exception_alert_dialog.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  String name;
  String email;
  bool enableSubmitBtn = false;
  String defaultState = 'Select';
  String defaultAge = '18';
  String defaultGender = 'Male';
  String defaultCity = 'Select';
  bool _isSubmit = false;
  bool _showNameError = true;
  bool _showEmailError = true;
  bool _isLoading = false;
  File _image;

  Future<void> onFormSubmit(BuildContext context) async {
    setState(() {
      _isSubmit = true;
      _isLoading = true;
    });

    try {
      final database = Provider.of<Database>(context, listen: false);
      UserInfo userInfo;
      if (_image != null) {
        var imgURL = await database.uploadImage(_image);
        userInfo = UserInfo(
          name: name,
          email: email,
          age: defaultAge,
          gender: defaultGender,
          joinedMatches: [],
          walletBalance: 0,
          profilePicURL: imgURL,
        );
      } else {
        userInfo = UserInfo(
          name: name,
          email: email,
          age: defaultAge,
          gender: defaultGender,
          joinedMatches: [],
          walletBalance: 0,
        );
      }
      await database.createUser(userInfo);
      SharedPref().saveUserInfo(userInfo);
      Provider.of<Data>(context, listen: false).updateUserInfo(userInfo);
      // after successfull registration handle referral bonus here
      await DynamicLinkService().handleReferralDynamicLink(name, context);
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      setState(() => _isLoading = false);
      PlatformExceptionAlertDialog(
        title: 'Operation Failed',
        exception: e,
      ).show(context);
    }
  }

  Future<void> getImage() async {
    var img = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(img.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Container(
        color: kAppBackgroundColor,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
                title: AppBarTitles.addDetails,
                backgroundColor: kAppBackgroundColor,
                automaticallyImplyLeading: false),
            body: ModalProgressHUD(
              inAsyncCall: _isLoading,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ImagePickerWidget(
                                image: _image,
                                priImageURL: null,
                                getImage: getImage,
                              ),
                              TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    errorText: _showNameError && _isSubmit
                                        ? 'Please enter your fullname'
                                        : null),
                                onChanged: (value) {
                                  name = value;
                                  setState(() {
                                    name.isEmpty
                                        ? _showNameError = true
                                        : _showNameError = false;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    errorText: _showEmailError && _isSubmit
                                        ? 'Please enter email address'
                                        : null),
                                onChanged: (value) {
                                  email = value;
                                  setState(() {
                                    email.isEmpty
                                        ? _showEmailError = true
                                        : _showEmailError = false;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20.0,
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
                                          defaultItem: defaultAge,
                                          onchange: (age) {
                                            setState(() {
                                              defaultAge = age;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
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
                                          defaultItem: defaultGender,
                                          onchange: (gender) {
                                            setState(() {
                                              defaultGender = gender;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              RectangleButton(
                                buttonTitle: 'Submit',
                                onPress: !_showEmailError && !_showNameError
                                    ? () => onFormSubmit(context)
                                    : null,
                              )
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
    );
  }
}
