import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise(BuildContext context) async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        PlatformAlertDialog(
          title: message['notification']['title'],
          content: message['notification']['body'],
          defaultActionText: 'OK',
        ).show(context);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        PlatformAlertDialog(
          title: message['data']['title'],
          content: message['data']['body'],
          defaultActionText: 'OK',
        ).show(context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        PlatformAlertDialog(
          title: message['notification']['title'],
          content: message['data']['body'],
          defaultActionText: 'OK',
        ).show(context);
      },
    );
  }

  Future<void> subscribeToNotification() async {
    // _fcm.
    await _fcm.subscribeToTopic('notification');
  }
}
