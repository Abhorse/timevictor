import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/data/shared_preferences.dart';
import 'package:timevictor/data/user.dart';
import 'package:timevictor/modals/user_info.dart' as UserData;
import 'package:timevictor/screens/authScreens/user_info_form.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/widgets/otp_modal.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:timevictor/widgets/platform_exception_alert_dialog.dart';

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;

  Future<User> currentUser();

  Future<User> signInAnonymously();

  Future<User> singInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  Future<void> signInWithPhoneNumber(BuildContext context, String mobileNumber,
      bool isLogin, Function setLoading);

  Future<void> signOut();
}

class Authentication implements AuthBase {
  final _auth = FirebaseAuth.instance;
  String verificationId;
  String smsCode;
  bool isLoginRequest;
  bool isNewUser = false;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    } else
      return User(uid: user.uid, isNewUser: isNewUser);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _auth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _auth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> singInWithEmailAndPassword(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _onSuccessfulVerification(
    BuildContext context,
    String uid,
    phoneNumber,
  ) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    SharedPref sharedPref = SharedPref();
    sharedPref.saveUID(uid);
    sharedPref.savePhoneNumber(phoneNumber);
    if (isNewUser) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Provider<Database>(
            create: (_) => FirestoreDatabase(uid: uid),
            child: UserInformation(),
          ),
        ),
      );
    } else {
      // FirestoreDatabase(uid: uid).streamUserInfo().listen((data) {
      //   UserData.UserInfo userInfo = UserData.UserInfo(
      //     name: data.name,
      //     email: data.email,
      //     age: data.age,
      //     gender: data.gender,
      //     profilePicURL: data.profilePicURL,
      //   );
      //   sharedPref.saveUserInfo(userInfo);
      //   final provider = Provider.of<Data>(context, listen: false);
      //   provider.updateUserInfo(userInfo);
      //   provider.updateUID(uid);
      //   provider.updatePhoneNumber(phoneNumber);
      // });

      try {
        UserData.UserInfo userInfo =
            await FirestoreDatabase(uid: uid).getUserInformation();
        await sharedPref.saveUserInfo(userInfo);
        final provider = Provider.of<Data>(context, listen: false);
        provider.updateUserInfo(userInfo);
        provider.updateUID(uid);
        provider.updatePhoneNumber(phoneNumber);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> signInWithPhoneNumber(BuildContext context, String mobileNumber,
      bool isLogin, Function setLoading) async {
    isLoginRequest = isLogin;
    await this._verifyPhone(mobileNumber, setLoading, context);
  }

  Future<void> _verifyPhone(
      String mobileNumber, Function toggleLoading, BuildContext context) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        toggleLoading();
      });
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) async {
      try {
        var user = await _auth.signInWithCredential(credential);
        if (user != null) {
          isNewUser = user.additionalUserInfo.isNewUser;
          _onSuccessfulVerification(
              context, user.user.uid, user.user.phoneNumber);
        }
        toggleLoading();
      } on PlatformException catch (e) {
        print(e);
        PlatformExceptionAlertDialog(
          title: 'Sign in Failed',
          exception: e,
        ).show(context);
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      toggleLoading();
      PlatformAlertDialog(
        title: 'Sign In Failed',
        content: exception.message,
        defaultActionText: 'OK',
      ).show(context);
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        timeout: const Duration(milliseconds: 1000),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verificationFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieval);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return OTPModal(
      context: context,
      onChange: (value) {
        this.smsCode = value;
      },
      onSubmitOTP: () => onSubmitOTP(context),
    ).show(context);
  }

  void onSubmitOTP(BuildContext context) {
    _auth.currentUser().then((user) {
      print(user != null);
      if (user != null) {
//                                _onSuccessfulVerification(user.phoneNumber);
        print('phone number ${user.phoneNumber}');
      } else {
        signIn(context);
      }
    });
  }

  signIn(BuildContext context) {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    _auth.signInWithCredential(phoneAuthCredential).then((user) {
      print('is user is new? ans: ${user.additionalUserInfo.isNewUser}');
      isNewUser = user.additionalUserInfo.isNewUser;
      Provider.of<Data>(context, listen: false).otpLoadingToggle(false);
      _onSuccessfulVerification(context, user.user.uid, user.user.phoneNumber);
    }).catchError((e) {
      Provider.of<Data>(context, listen: false).otpLoadingToggle(false);
      PlatformAlertDialog(
        title: 'Invaild OTP',
        content: e.message,
        defaultActionText: 'OK',
      ).show(context);
    });
  }
}
