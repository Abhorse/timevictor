import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:timevictor/constants.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  List<Widget> allColorButton() {
    List<Widget> btns = [];
    kColorCodes.forEach((colorCode) {
      btns.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          width: 30.0,
          height: 20.0,
          child: FlatButton(
            shape: kCardShape(5),
            color: Color(colorCode),
            child: Text(''),
            onPressed: () {
              setState(() {
                kAppBackgroundColor = Color(colorCode);
              });
              FlutterStatusbarcolor.setStatusBarColor(kAppBackgroundColor);
            },
          ),
        ),
      ));
    });

    return btns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
        backgroundColor: kAppBackgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Choose your app theme',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: allColorButton(),
            ),
          ),
        ],
      ),
    );
  }
}
