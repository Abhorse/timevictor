import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/bLoCs/phone_sign_in_bloc.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/modals/phone_sign_in_model.dart';
import 'package:timevictor/services/auth.dart';
import 'package:timevictor/widgets/CircularButton.dart';
import 'package:timevictor/widgets/SwitchSignInSignUpButton.dart';
import 'package:timevictor/widgets/platform_exception_alert_dialog.dart';

class LoginScreenBlocBased extends StatefulWidget {
  const LoginScreenBlocBased({@required this.bloc, this.child, @required this.isLogin});

  final PhoneSignInBloc bloc;
  final Widget child;
  final bool isLogin;

  static Widget create({BuildContext context, Widget child, bool isLoginScreen}) {
    final Authentication auth = Provider.of<Authentication>(context);
    return Provider<PhoneSignInBloc>(
      create: (_) => PhoneSignInBloc(auth: auth),
      child: Consumer<PhoneSignInBloc>(
        builder: (context, bloc, _) => LoginScreenBlocBased(bloc: bloc, child: child, isLogin: isLoginScreen),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _LoginScreenBlocBasedState createState() => _LoginScreenBlocBasedState();
}

class _LoginScreenBlocBasedState extends State<LoginScreenBlocBased> {

  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      await widget.bloc.signInWithPhoneNumber(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
    }
  }

  Widget androidDropdown(PhoneSignInModel model) {
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
      value: model.countryCode,
      items: list,
      onChanged: (value) {
        widget.bloc.updateWith(countryCode: value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
//    return Container(
//      color: kAppBackgroundColor,
//      child: SafeArea(
//        child: Scaffold(
//          resizeToAvoidBottomInset: false,
//          appBar: AppBar(
//            title: Text('LOG IN'),
//            backgroundColor: kAppBackgroundColor,
//          ),
//          body: _buildContent(context),
//        ),
//      ),
//    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<PhoneSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: PhoneSignInModel(),
        builder: (context, snapshot) {
          final PhoneSignInModel model = snapshot.data;
          return ModalProgressHUD(
            color: kAppBackgroundColor,
            inAsyncCall: model.showSpinner,
            child: Column(
              children: <Widget>[
                widget.child,
                Padding(
                  padding: const EdgeInsets.all(20.0),
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
                                    child: androidDropdown(model),
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
                                  onEditingComplete: model.isNumberValid
                                      ? () => _signInWithPhoneNumber(context)
                                      : null,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      labelText: 'Mobile Number',
                                      errorText: model.mobileNumberErrorText,
                                  ),
                                  onChanged: widget.bloc.updateMobileNumber,
                                ),
                              ),
                            ],
                          ),
                          RectangleButton(
                              buttonTitle: 'Request for OTP',
                              onPress: !model.isNumberValid
                                  ? null
                                  : () => _signInWithPhoneNumber(context)),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SwitchSignInSignUpButton(isLoginScreen: widget.isLogin),
                )
              ],
            ),
          );
        });
  }
}
