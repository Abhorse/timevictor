import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/data/shared_preferences.dart';
import 'package:timevictor/modals/user_info.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/platform_dropdown.dart';
import 'package:timevictor/widgets/platform_exception_alert_dialog.dart';

import 'package:timevictor/constants.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String name;
  String email;
  String defaultAge = '18';
  String defaultGender = 'Male';
  bool _isLoading = false;

  void setInitial() async {
    UserInfo user = await SharedPref().getUserInfo();
    setState(() {
      name = user.name;
      email = user.email;
      defaultAge = user.age;
      defaultGender = user.gender;
    });
  }

  Future<void> onFormSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('$name , $email, $defaultAge, $defaultGender');
      final database = Provider.of<Database>(context, listen: false);
      UserInfo userInfo = UserInfo(
        name: name,
        email: email,
        age: defaultAge,
        gender: defaultGender,
      );
      await database.createUser(userInfo);
      SharedPref sharedPref = SharedPref();
      await sharedPref.saveUserInfo(userInfo);
      Provider.of<Data>(context, listen: false)
          .updateUserInfo(await sharedPref.getUserInfo());
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

  @override
  Widget build(BuildContext context) {
//    setInitial();
//    final user = Provider.of<Data>(context).user;
//    defaultAge = user.age;
//    defaultGender = user.gender;
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
            onPressed: () => onFormSubmit(context),
          )
        ],
      ),
      body: ModalProgressHUD(
        color: kAppBackgroundColor,
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: name,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'Name'),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email'),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
