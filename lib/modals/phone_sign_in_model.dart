class PhoneSignInModel {
  PhoneSignInModel(
      {this.mobileNumber = '',
      this.isNumberValid = false,
      this.isContainCountryCode = false,
      this.showSpinner = false,
      this.countryCode = '+91',
      this.isSubmitted = false});

  final String mobileNumber;
  final bool isNumberValid;
  final bool isContainCountryCode;
  final bool showSpinner;
  final String countryCode;
  final bool isSubmitted;

  String get mobileNumberErrorText {
    bool showErrorText = !isNumberValid && isSubmitted;
    return showErrorText ? 'Phone Number Can\'t be Empty' : null;
  }

  copyWith({
    String mobileNumber,
    bool isNumberValid,
    bool isContainCountryCode,
    bool showSpinner,
    String countryCode,
    bool isSubmitted,
  }) {
    return PhoneSignInModel(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      isNumberValid: isNumberValid ?? this.isNumberValid,
      isContainCountryCode: isContainCountryCode ?? this.isContainCountryCode,
      showSpinner: showSpinner ?? this.showSpinner,
      countryCode: countryCode ?? this.countryCode,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}
