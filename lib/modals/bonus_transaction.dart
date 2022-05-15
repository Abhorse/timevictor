import 'package:cloud_firestore/cloud_firestore.dart';

class BonusTransaction {
  final String id;
  final int bonusAmonut;
  final String by;
  final Timestamp date;
  final bool isCredited;

  BonusTransaction({
    this.id,
    this.bonusAmonut,
    this.by,
    this.date,
    this.isCredited,
  });

  factory BonusTransaction.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    final String id = data['id'];
    final int bonusAmonut = data['bonusAmount'];
    final String by = data['by'];
    final Timestamp date = data['date'];
    final bool isCredited = data['isCredited'];

    return BonusTransaction(
      id: id,
      bonusAmonut: bonusAmonut,
      by: by,
      date: date,
      isCredited: isCredited,
    );
  }
}
