import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String msg;
  final Color backgoundColor;

  const CustomSnackBar({
    Key key,
    this.msg,
    this.backgoundColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(msg),
      backgroundColor: backgoundColor,
    );
  }
}
