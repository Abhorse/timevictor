import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final Function onPress;
  final String buttonTitle;

  RectangleButton({this.onPress, this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        height: 50.0,
        child: FlatButton(
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)) ,
          onPressed: onPress,
          color: Colors.green,
          child: Text(buttonTitle),
        ),
      ),
    );
  }
}
