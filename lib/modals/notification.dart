import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timevictor/utils/dateTime_formater.dart';

class NotificationData {
  final String title;
  final String message;
  final String date;

  NotificationData({
    this.title,
    this.message,
    this.date,
  });

  factory NotificationData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String title = data['title'];
    final String message = data['message'];
    final Timestamp date = data['date'];

    final formatedDate = FormattedDateTime.paymentFormat(date);

    return NotificationData(
      title: title,
      message: message,
      date: formatedDate,
    );
  }
}
