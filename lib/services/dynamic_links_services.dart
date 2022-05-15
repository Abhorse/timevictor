import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:timevictor/constants.dart';
import 'package:timevictor/services/database.dart';
import 'package:timevictor/utils/helper.dart';

class DynamicLinkService {
  bool isReferralDone = false;
  Future<Uri> createDynamicLink(String userID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://timevictor.page.link',
      link: Uri.parse('https://www.timevictor.com/?referralCode=$userID'),
      androidParameters: AndroidParameters(
        packageName: 'com.timevictor.timevictor',
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.timevictor.timevictor',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(kTVLogoURL),
        title: 'Time Victor',
        description:
            'I found this amazing app which is to help students to earn and let fantacy users to enjoy!',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri dynamicUrl = shortDynamicLink.shortUrl;

    print(dynamicUrl);
    return dynamicUrl;
  }

  Future handleReferralDynamicLink(
      String userName, BuildContext context) async {
    // final PendingDynamicLinkData data =
    //     await FirebaseDynamicLinks.instance.getInitialLink();

    // if (!isReferralDone) {
    //   _handleDeepLink(data, userName);
    //   isReferralDone = true;
    // }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
        if (!isReferralDone) {
          _handleDeepLink(dynamicLinkData, userName);
          isReferralDone = true;
        }
      },
      // onSuccess: DoubleCallFilter<PendingDynamicLinkData>(
      //   action: (dynamicLinkData) async {
      //     _handleDeepLink(dynamicLinkData, userName, context);
      //   },
      // ),
      onError: (OnLinkErrorException e) async {
        print('Dynamic Link Failed: ${e.message}');
      },
    );
  }
}

Future<void> _handleDeepLink(
    PendingDynamicLinkData data, String userName) async {
  final Uri deepLink = data?.link;
  if (deepLink != null) {
    var referralCode = deepLink.queryParameters['referralCode'];
    print('_handleDeepLink | $referralCode deepLink: $deepLink');
    if (referralCode != null && referralCode.isNotEmpty) {
      try {
        String bonusAmount = await Helper.getRemoteValueByKey('bonus_amount');
        await FirestoreDatabase(uid: '').addReferralBonus(
            referralCode, userName, double.parse(bonusAmount));
      } catch (e) {
        print(e);
      }
    }
  }
}

class DoubleCallFilter<T> {
  T _lastValue;
  int _lastValueTime = 0;
  final int timeoutMs;
  final Future Function(T) action;

  DoubleCallFilter({@required this.action, this.timeoutMs = 500});

  Future<dynamic> call(T value) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (_lastValue == value) {
      if (currentTime - _lastValueTime <= timeoutMs) {
        return;
      }
    }
    _lastValue = value;
    _lastValueTime = currentTime;
    if (action != null) await action(_lastValue);
  }
}
