import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  final String thirdPartyName;
  final String icon;
  final Color iconColour;
  final Color cardColor;
  final TextStyle textStyle;

  LoginCard({this.thirdPartyName, this.icon, this.iconColour, this.textStyle, this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
//            ImageIcon(
//              icon,
//              color: iconColour,
//            ),
            Image.asset(icon),
            SizedBox(
              width: 10.0,
            ),
            Text(
              thirdPartyName,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}