import'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/widgets/otp_widget.dart';

class OTPModal extends OTPWidget {
  OTPModal({
    @required this.context,
    @required this.onSubmitOTP,
    @required this.onChange,
  })  : assert(onSubmitOTP != null),
        assert(context != null),
        assert(onChange != null);

  final BuildContext context;
  final Function onChange;
  final Function onSubmitOTP;


  Future<bool> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => this,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<Data>(context).isOTPSending,
      child: SingleChildScrollView(
        child: Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: Color(0xff757575),
            child: StreamBuilder<bool>(
              stream: null,
              builder: (context, snapshot) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Enter OTP to verify your Mobile Number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          onChanged: onChange,
                        ),
                        FlatButton(
                          color: Colors.red,
                          child: Text(
                            'Submit OTP',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Provider.of<Data>(context, listen: false).otpLoadingToggle(true);
                            FocusScope.of(context).unfocus();
                            onSubmitOTP();
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
