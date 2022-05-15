import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:timevictor/data/provider_data.dart';
import 'package:timevictor/widgets/platform_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class Helper {
  static Future<void> openTermAndConditionLink(BuildContext context) async {
    if (await canLaunch(kTermsAndConditionsURL)) {
      await launch(kTermsAndConditionsURL);
    } else {
      PlatformAlertDialog(
        title: 'Launch Failed',
        content: 'Could not launch $kTermsAndConditionsURL',
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  static Future<void> openLink(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      PlatformAlertDialog(
        title: 'Launch Failed',
        content: 'Could not launch $url',
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  static void customSnackBar({
    BuildContext context,
    String message,
    Color color,
  }) {
    final snackbar = SnackBar(
      backgroundColor: color ?? kAppBackgroundColor,
      content: Text(message ?? 'Hey, I\'m SnackBar'),
      behavior: SnackBarBehavior.floating,
      shape: kButtonShape,
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  static Future<String> getRemoteValueByKey(String key) async {
    String value = '';
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      await remoteConfig.fetch(expiration: const Duration(minutes: 5));
      await remoteConfig.activateFetched();
      if (remoteConfig.getValue(key) != null) {
        value = remoteConfig.getValue(key).asString();
      }
    } catch (e) {
      print(e);
    }
    return value;
  }

  static Future<List<String>> getMinWithdrawAmountAndFee() async {
    List<String> value = [];
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      await remoteConfig.fetch(expiration: const Duration(minutes: 5));
      await remoteConfig.activateFetched();
      if (remoteConfig.getValue('key') != null) {
        value.add(remoteConfig.getValue('key').asString());
      }
    } catch (e) {
      print(e);
    }
    return value;
  }

  static Future<PackageInfo> getCurrentPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  static Future<bool> isUpdateNeeded(BuildContext context) async {
    bool isUpdateNeeded = false;
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      await remoteConfig.fetch(expiration: const Duration(minutes: 5));
      await remoteConfig.activateFetched();
      PackageInfo packageInfo = await getCurrentPackageInfo();

      String latestVerions =
          remoteConfig.getValue("latest_release_version").asString();
      String currentVersion = packageInfo.version;
      isUpdateNeeded = currentVersion != latestVerions;
      Provider.of<Data>(context, listen: false).updateAppVerion(currentVersion);
    } catch (e) {
      PlatformAlertDialog(
        title: 'Error',
        content:
            'Not able to fetch your data, please check your network connection',
        defaultActionText: 'OK',
      ).show(context);
      return null;
    }
    return isUpdateNeeded;
  }

  static shareLink({@required String link}) {
    Share.share(link);
  }
}
