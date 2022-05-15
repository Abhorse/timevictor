import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor/constants.dart';

class StartUpUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: false,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        kAppBackgroundColor,
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.5, 0.5])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        height: 120.0,
                        width: 120.0,
                        image: AssetImage('assets/images/tvLogoFinal.png'),
                      ),
                    ],
                  ),
                  Text(
                    'A Hero Among You',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe05e63),
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
