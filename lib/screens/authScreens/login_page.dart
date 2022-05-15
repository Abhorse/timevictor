import 'package:flutter/material.dart';
import 'package:timevictor/screens/authScreens/login_screen_bloc_based.dart';
import 'package:timevictor/widgets/LoginCard.dart';
import '../../constants.dart';

class LoginPage extends StatelessWidget {
  Widget getChild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // TODO: Impelement the third party authentications
          // LoginCard(
          //   cardColor: Color(0xFF334D92),
          //   thirdPartyName: 'Facebook',
          //   icon: 'assets/images/facebook-logo.png',
          //   textStyle: TextStyle(color: Colors.white),
          // ),
          // LoginCard(
          //   icon: 'assets/images/google-logo.png',
          //   thirdPartyName: 'Google',
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: AppBarTitles.login,
            backgroundColor: kAppBackgroundColor,
          ),
          body: LoginScreenBlocBased.create(
            context: context,
            child: getChild(context),
            isLoginScreen: true,
          ),
        ),
      ),
    );
  }
}
