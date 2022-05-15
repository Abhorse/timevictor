import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/bLoCs/sign_In_BLoC.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/screens/authScreens/oldFlow/registration_screen.dart';
import 'package:timevictor/services/auth.dart';
import 'package:timevictor/widgets/CircularButton.dart';
import 'package:timevictor/widgets/LoginCard.dart';
import 'package:timevictor/widgets/platform_exception_alert_dialog.dart';

class LoginScreen extends StatefulWidget {
  static Widget create(BuildContext context) {
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(),
      child: LoginScreen(),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String mobileNumber = '';
  bool isNumberValid = false;
  bool isContainCountryCode = false;
  bool showSpinner = false;
  String countryCode = '+91';
  bool isSubmitted = false;

  void toggleLoading() {
    setState(() {
      showSpinner = !showSpinner;
    });
  }

  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    FocusScope.of(context).unfocus();
    setState(() {
      showSpinner = true;
      isSubmitted = true;
    });
    try {
      String number = countryCode + mobileNumber;
      final auth = Provider.of<Authentication>(context, listen: false);
      await auth.signInWithPhoneNumber(context, number, true, toggleLoading);
    } on PlatformException catch (e) {
      toggleLoading();
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
    }
  }

  Widget androidDropdown() {
    List<DropdownMenuItem<String>> list = [];
    for (String code in kCountryCodeList) {
      list.add(
        DropdownMenuItem(
          child: Text(
            code,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          value: code,
        ),
      );
    }

    return DropdownButton<String>(
      underline: Container(
        height: 0,
      ),
      elevation: 16,
      value: countryCode,
      items: list,
      onChanged: (value) {
        setState(() {
          countryCode = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAppBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('LOG IN'),
            backgroundColor: kAppBackgroundColor,
          ),
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        LoginCard(
                          cardColor: Color(0xFF334D92),
                          thirdPartyName: 'Facebook',
                          icon: 'assets/images/facebook-logo.png',
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        LoginCard(
                          icon: 'assets/images/google-logo.png',
                          thirdPartyName: 'Google',
                        ),
                      ],
                    ),
                    Center(child: Text('or')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: androidDropdown(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          flex: 5,
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: isNumberValid
                                ? () => _signInWithPhoneNumber(context)
                                : null,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                labelText: 'Mobile no.',
                                errorText: !isNumberValid && isSubmitted
                                    ? 'Phone Number Can\'t be Empty'
                                    : null),
                            onChanged: (value) {
                              mobileNumber = value;
                              setState(() {
                                mobileNumber.isEmpty
                                    ? isNumberValid = false
                                    : isNumberValid = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    RectangleButton(
                      buttonTitle: 'Request for OTP',
                      onPress: !(isNumberValid)
                          ? null
                          : () => _signInWithPhoneNumber(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));
              },
              child: Text('Not a member? Register'),
            ),
          )
        ],
      ),
    );
  }
}
