import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/screens/authScreens/login_screen_bloc_based.dart';
import 'package:timevictor/utils/helper.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneAuth extends StatelessWidget {
  Widget getChild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'By registering, I agree to TimeVictor\'s',
            style: TextStyle(color: Colors.grey),
          ),
          GestureDetector(
            onTap: () async {
              await Helper.openTermAndConditionLink(context);
            },
            child: Text(
              ' T&Cs',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: AppBarTitles.register,
      ),
      body: LoginScreenBlocBased.create(
        context: context,
        child: getChild(context),
        isLoginScreen: false,
      ),
    );
  }
}
