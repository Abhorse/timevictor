import 'package:flutter/foundation.dart';

class ValidateModel {
  ValidateModel({@required this.isValid, this.title, this.content});

  final bool isValid;
  final String title;
  final String content;
}
