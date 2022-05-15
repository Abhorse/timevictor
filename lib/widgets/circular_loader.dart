import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kAppBackgroundColor),
          ),
        ),
      ),
    );
  }
}
