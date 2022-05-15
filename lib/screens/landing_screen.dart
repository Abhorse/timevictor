import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/user.dart';
import 'package:timevictor/screens/home/home_screen.dart';
import 'package:timevictor/screens/authScreens/welcome_screen.dart';
import 'package:timevictor/screens/startup_ui.dart';
import 'package:timevictor/services/auth.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/circular_loader.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return WelcomeScreen();
          } else {
            return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomeScreen(),
            );
          }
        } else
          // return Scaffold(body: CircularLoader());
          return StartUpUI();
      },
    );
  }
}
