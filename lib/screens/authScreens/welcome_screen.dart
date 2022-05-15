import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/data/shared_preferences.dart';
import 'package:timevictor/screens/authScreens/login_page.dart';
import 'package:timevictor/screens/authScreens/phone_auth.dart';
import 'package:timevictor/widgets/LoginButton.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
                color: kAppBackgroundColor,
                gradient: LinearGradient(
                  colors: [ kAppBackgroundColor, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [ 0.5, 0.5],
                )),
            child: Stack(
              children: [
                Container(
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
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //TODO: Implementation of anonymus login
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                   child: Container(
//                     height: 50.0,
//                     child: FlatButton(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0)),
//                       child: Text(
//                         "Let's Play",
//                         style: TextStyle(color: Colors.white, fontSize: 20.0),
//                       ),
//                       color: kAppBackgroundColor,
//                       onPressed: () async {
//                         //Todo: (anonymous login) Will Implement later
//                         print(await SharedPref().getPhoneNumber());
//                         print(await SharedPref().getUID());
// //                      Navigator.push(
// //                        context,
// //                        MaterialPageRoute(
// //                          builder: (context) {
// //                            return HomeScreen();
// //                          },
// //                        ),
// //                      );
//                       },
//                     ),
//                   ),
//                 ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Divider(
                          color: kAppBackgroundColor,
                          thickness: 5.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  LoginButton(
                                    onPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return PhoneAuth();
                                          },
                                        ),
                                      );
                                    },
                                    isLoginbtn: false,
                                    text: 'Have a referral code?',
                                    buttonTitle: 'Enter Code',
                                  ),
                                  LoginButton(
                                    text: 'Already a user?',
                                    buttonTitle: 'Log in',
                                    isLoginbtn: true,
                                    onPress: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return LoginPage();
                                      }));
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
