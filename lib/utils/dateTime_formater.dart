import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timevictor/constants.dart';

class FormattedDateTime {
  static String formate(Timestamp timestamp, int duration) {
    DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    var endTime = dateTime.add(Duration(minutes: duration));
    if (endTime.isBefore(DateTime.now())) return 'Closed';
    if (dateTime.isBefore(DateTime.now())) return 'LIVE';
    return getDay(dateTime) + ' ' + getTime(dateTime);
  }

  static String getDay(DateTime dateTime) {
    int day = dateTime.day;
    DateTime now = DateTime.now();
    if (day == now.day) return 'Today';
    if (day == now.day + 1) return 'Tomorrow';
    return '$day ${kMonths[dateTime.month - 1]}';
  }

  static String getTime(DateTime dateTime) {
    String ampm = dateTime.hour > 11 ? 'PM' : 'AM';
    String hour =
        dateTime.hour > 11 ? '${(dateTime.hour - 12)}' : '${dateTime.hour}';
    String min = dateTime.minute < 10
        ? '0${dateTime.minute}'
        : dateTime.minute.toString();

    return '$hour:$min $ampm';
  }

  static String paymentFormat(Timestamp timestamp) {
    DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    return getDay(dateTime) + ' ' + getTime(dateTime);
  }

  static String timeLeftFromNow(Timestamp timestamp, int duration) {
    DateTime dateTime = DateTime.parse(timestamp.toDate().toString());
    var endTime = dateTime.add(Duration(minutes: duration));
    if (endTime.isBefore(DateTime.now())) return 'Closed';
    if (dateTime.isBefore(DateTime.now())) return 'LIVE';
    Duration difference = DateTime.now().difference(dateTime).abs();
    print(difference);
    if (difference.inDays >= 2) {
      print('${difference.inDays} Days');
      return '${difference.inDays} Days';
    }
    if (difference.inHours >= 24) {
      print('${difference.inHours}h');
      return '${difference.inHours}h';
    }
    if (difference.inHours > 0) {
      var min = difference.inMinutes - (difference.inHours * 60);
      print('${difference.inHours}h ${min}m');
      return '${difference.inHours}h ${min}m';
    }
    if (difference.inMinutes > 59) {
      print('${difference.inMinutes}m');
      return '${difference.inMinutes}m';
    }
    if (difference.inMinutes > 0) {
      var sec = difference.inSeconds - (difference.inMinutes * 60);
      print('${difference.inMinutes}m ${sec}s');
      return '${difference.inMinutes}m ${sec}s';
    }
    if (difference.inSeconds >= 0) {
      print('${difference.inSeconds}s');
      return '${difference.inSeconds}s';
    }

    return getDay(dateTime) + ' ' + getTime(dateTime);
  }
}
