import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/screens/authScreens/oldFlow/login_screen.dart';
import 'package:timevictor/services/auth.dart';
import 'package:timevictor/widgets/CircularButton.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String mobileNumber;
  String countryCode = '+91';
  bool showSpinner = false;
  bool isNumberValid = false;
  bool isSubmitted = false;
  List<String> countryCodeList = ['+91', '+92', '+997'];

  void toggleLoading () {
    setState(() {
      showSpinner = !showSpinner;
    });
  }

  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    print(countryCode + mobileNumber);
    FocusScope.of(context).unfocus();
    setState(() {
      showSpinner = true;
      isSubmitted = true;
    });
    try {
      final String number = countryCode + mobileNumber;
      print('number $number');
      final auth = Provider.of<Authentication>(context, listen: false);
      await auth.signInWithPhoneNumber(context, number, false, toggleLoading);
    } catch (e) {
      toggleLoading();
      PlatformAlertDialog(
        title: 'Verification Failed',
        content: '${e.toString()}',
        defaultActionText: 'OK',
      );
    }
  }

  Widget androidDropdown () {
    List<DropdownMenuItem<String>> list = [];
    for(String code in countryCodeList) {
      list.add(DropdownMenuItem(
        child: Text(code, style: TextStyle(fontWeight: FontWeight.w700),),
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

  Widget iosPicker () {
    List<Text> list = [];
    for(String code in countryCodeList){
      list.add(Text(code, style: TextStyle(color: Colors.white),));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
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
                            SizedBox(width: 20.0,),
                            Expanded(
                              flex: 5,
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Mobile no.',
                                  errorText: !isNumberValid && isSubmitted ? 'enter a valid number' : null,
                                ),
                                onChanged: (value) {
                                  mobileNumber = value;
                                  setState(() {
                                    mobileNumber.isEmpty ? isNumberValid = false : isNumberValid = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        RectangleButton(
                          buttonTitle: 'Get OTP',
                          onPress: isNumberValid ? () => _signInWithPhoneNumber(context) : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'By registering, I agree to TimeVictor\'s',
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Todo: Navigate to T&C page
                                },
                                child: Text(
                                  ' T&Cs',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Center(
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text('Alredy a user?Log in'),
              ),
            ),
          ],
        ),
      );
  }
}
