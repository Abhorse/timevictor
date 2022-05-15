import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RazorPayX {
  static const String baseAPI = "https://api.razorpay.com/v1";

  static Future<List<String>> getAPIKey() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(minutes: 5));
    await remoteConfig.activateFetched();
    String sk = remoteConfig.getValue('razorpay_key_secret').asString();
    String apiKey = remoteConfig.getValue('razorpay_key_id').asString();
    String minWithdrowAmount =
        remoteConfig.getValue('min_Withdrow_amount').asString();
    String account = remoteConfig.getValue('account_number').asString();
    return [apiKey, sk, minWithdrowAmount, account];
  }

  static Future<dynamic> createContact({
    @required String name,
    @required String contact,
    @required String email,
  }) async {
    String url = baseAPI + '/contacts';
    List<String> keys = await getAPIKey();
    // List<String> keys = ["rzp_test_2FFfSkdzEWG2ga", "EPhz2sCwvB260hZcjsxVH321"];
    String basicAuth = 'Basic ' +
        convert.base64Encode(convert.utf8.encode("${keys[0]}:${keys[1]}"));

    var response = await http.post(
      url,
      headers: <String, String>{
        'authorization': basicAuth,
        "Content-Type": "application/json",
      },
      body: convert.jsonEncode({
        "name": name,
        "email": email,
        "contact": contact,
        "type": "customer",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  static Future<dynamic> createFundAccount({
    @required String contactId,
    @required String name,
    @required String ifscCode,
    @required String accountNumber,
  }) async {
    String url = baseAPI + '/fund_accounts';
    List<String> keys = await getAPIKey();
    // List<String> keys = ["rzp_test_2FFfSkdzEWG2ga", "EPhz2sCwvB260hZcjsxVH321"];
    String basicAuth = 'Basic ' +
        convert.base64Encode(convert.utf8.encode("${keys[0]}:${keys[1]}"));
    var response = await http.post(
      url,
      headers: <String, String>{
        'authorization': basicAuth,
        "Content-Type": "application/json",
      },
      body: convert.jsonEncode(
        {
          "contact_id": contactId,
          "account_type": 'bank_account',
          "bank_account": {
            "name": name,
            "ifsc": ifscCode,
            "account_number": accountNumber,
          }
        },
      ),
    );
    return response;
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   var jsonResponse = convert.jsonDecode(response.body);
    //   print(jsonResponse);
    //   return jsonResponse;
    // } else {
    //   var jsonResponse = convert.jsonDecode(response.body);
    //   print(jsonResponse);
    //   print('Request failed with status: ${response.statusCode}.');
    //   return null;
    // }
  }

  static Future<dynamic> createPayoutRequest({
    @required String fundAccountId,
    @required int amount,
  }) async {
    String url = baseAPI + '/payouts';
    List<String> keys = await getAPIKey();
    // List<String> keys = ["rzp_test_2FFfSkdzEWG2ga", "EPhz2sCwvB260hZcjsxVH321"];
    // int minAmount = int.parse(keys[2]);
    if (amount > 0) {
      String basicAuth = 'Basic ' +
          convert.base64Encode(convert.utf8.encode("${keys[0]}:${keys[1]}"));
      var response = await http.post(
        url,
        headers: <String, String>{
          'authorization': basicAuth,
          "Content-Type": "application/json",
        },
        body: convert.jsonEncode({
          "account_number": keys[3],
          "fund_account_id": fundAccountId,
          "amount": amount * 100,
          "currency": "INR",
          "mode": "IMPS",
          "purpose": "payout",
          "queue_if_low_balance": true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
        return jsonResponse;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } else
      return null;
  }

  static Future<http.Response> createOrder(int amount, String receipt) async {
    receipt = receipt.replaceAll(new RegExp(r"\s+"), '');
    const String url = "${RazorPayX.baseAPI}/orders";
    List<String> keys = await RazorPayX.getAPIKey();
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('${keys[0]}:${keys[1]}'));
    var response = await http.post(
      url,
      headers: <String, String>{'authorization': basicAuth},
      body: {
        "amount": '${amount * 100}',
        "currency": "INR",
        "receipt": receipt,
        "payment_capture": '1',
      },
    );
    return response;
  }
}
