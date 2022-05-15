import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  LoginButton({this.onPress, this.buttonTitle, this.text, this.isLoginbtn});

  final Function onPress;
  final String buttonTitle;
  final String text;
  final bool isLoginbtn;

  @override
  Widget build(BuildContext context) {
//    return FlatButton(child: Text(buttonTitle,
//                style: TextStyle(
//            fontSize: 20.0,
//            fontWeight: FontWeight.w900
//        ),
//        ),onPressed: onPress,);
    return GestureDetector(
      onTap: onPress,
      child: Column(
        crossAxisAlignment:
            isLoginbtn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(text),
          Text(
            buttonTitle,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
