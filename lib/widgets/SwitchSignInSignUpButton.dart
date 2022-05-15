import 'package:flutter/material.dart';
import 'package:timevictor/screens/authScreens/login_page.dart';
import 'package:timevictor/screens/authScreens/phone_auth.dart';

class SwitchSignInSignUpButton extends StatelessWidget {

  SwitchSignInSignUpButton({this.isLoginScreen});
  final bool isLoginScreen;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isLoginScreen ? PhoneAuth() : LoginPage(),
          ),
        );
      },
      child: Text(
        isLoginScreen ? 'Not a member? Register' : 'Alredy a user?Log in',
      ),
    );
  }
}
