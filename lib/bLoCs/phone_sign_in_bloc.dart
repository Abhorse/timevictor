import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timevictor/modals/phone_sign_in_model.dart';
import 'package:timevictor/services/auth.dart';

class PhoneSignInBloc {
  PhoneSignInBloc({@required this.auth});

  final Authentication auth;
  final StreamController<PhoneSignInModel> _modelController =
      StreamController<PhoneSignInModel>();

  Stream<PhoneSignInModel> get modelStream => _modelController.stream;
  PhoneSignInModel _model = PhoneSignInModel();

  void dispose() => _modelController.close();

  void updateMobileNumber (String number) {
    updateWith(
      mobileNumber: number,
      isNumberValid: number.isEmpty ? false : true,
    );
  }

  void updateWith({
    String mobileNumber,
    bool isNumberValid,
    bool isContainCountryCode,
    bool showSpinner,
    String countryCode,
    bool isSubmitted,
  }) {
    _model = _model.copyWith(
        mobileNumber: mobileNumber,
        isNumberValid: isNumberValid,
        isContainCountryCode: isContainCountryCode,
        showSpinner: showSpinner,
        countryCode: countryCode,
        isSubmitted: isSubmitted);

    _modelController.add(_model);
  }

  Future<void> signInWithPhoneNumber(BuildContext context) async {
    updateWith(showSpinner: true, isSubmitted: true);
    try {
      String number = _model.countryCode + _model.mobileNumber;
      await auth.signInWithPhoneNumber(
          context, number, true, () => updateWith(showSpinner: false));
    } catch (e) {
      updateWith(showSpinner: false);
      rethrow;
    }
  }
}
