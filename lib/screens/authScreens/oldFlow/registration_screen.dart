import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
// import 'package:timevictor/data/user.dart';
// import 'package:timevictor/screens/authScreens/login_screen_bloc_based.dart';
// import 'package:timevictor/screens/authScreens/phone_auth.dart';
import 'package:timevictor/screens/authScreens/oldFlow/phone_verification.dart';
import 'package:timevictor/services/auth.dart';
import 'package:timevictor/widgets/circular_loader.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context);
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Registration'),
            backgroundColor: kAppBackgroundColor,
          ),
          body: StreamBuilder(
            stream: auth.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return PhoneVerification();
              } else {
                return Scaffold(body: CircularLoader());
              }
            },
          ),
        ),
      ),
    );
  }
}
