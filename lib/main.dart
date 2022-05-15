import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/screens/landing_screen.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/screens/version_checker.dart';
import 'package:timevictor/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(kAppBackgroundColor);
    return ChangeNotifierProvider<Data>(
      create: (_) => Data(),
      child: Provider<Authentication>(
        create: (context) => Authentication(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            // body: LandingScreen(),
            body: VersionChecker(),
          ),
        ),
      ),
    );
  }
}
