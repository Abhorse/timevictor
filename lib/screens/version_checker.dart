import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/screens/landing_screen.dart';
import 'package:timevictor/screens/startup_ui.dart';
import 'package:timevictor/screens/update_app_view.dart';
import 'package:timevictor/utils/helper.dart';

class VersionChecker extends StatelessWidget {
  Widget networkErrorMessage(BuildContext context) {
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kAppBackgroundColor, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.5, 0.5],
              ),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                child: Card(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 40.0,
                          color: Colors.grey,
                        ),
                        Text(
                          'network error',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Text(
                            'Please check your internet connection and then refresh or restart the app',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Colors.green,
                          child: Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            build(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Helper.isUpdateNeeded(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool latestVersion = snapshot.data;
          if (latestVersion == null) {
            return networkErrorMessage(context);
          }
          if (!latestVersion) {
            return LandingScreen();
          } else
            // return UpdateAppView();
            return LandingScreen();
        } else
          // return CircularLoader();
          return StartUpUI();
      },
    );
  }
}
