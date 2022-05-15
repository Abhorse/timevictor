import 'package:cloud_firestore/cloud_firestore.dart';

class PayTransaction {
  final String transactionID;
  final Timestamp time;
  final int amount;
  final String contestName;
  final String match;
  final bool isSuccess;
  final bool isDebited;
  final String paymentMethod;
  final String orderId;
  final String signature;

  PayTransaction({
    this.transactionID,
    this.time,
    this.amount,
    this.contestName,
    this.match,
    this.isDebited,
    this.isSuccess,
    this.paymentMethod,
    this.orderId,
    this.signature,
  });

  factory PayTransaction.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String transactionID = data['transactionID'];
    final Timestamp time = data['time'];
    final int amount = data['amount'];
    final String contestName = data['contestName'];
    final String match = data['match'];
    final bool isSuccess = data['isSuccess'];
    final bool isDebited = data['isDebited'];
    final String paymentMethod = data['paymentMethod'];

    return PayTransaction(
      transactionID: transactionID,
      time: time,
      amount: amount,
      contestName: contestName,
      match: match,
      isDebited: isDebited,
      isSuccess: isSuccess,
      paymentMethod: paymentMethod,
    );
  }

  Map<String, dynamic> toMap() => {
        "transactionID": transactionID,
        "time": time,
        "amount": amount,
        "contestName": contestName,
        "match": match,
        "isDebited": isDebited,
        "isSuccess": isSuccess,
        "paymentMethod": paymentMethod,
        "orderId": orderId,
        "signature": signature,
      };
}
