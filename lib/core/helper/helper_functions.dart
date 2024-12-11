import 'package:flutter/material.dart';

extension MediaQuerySize on BuildContext {
  double screenHeight() => MediaQuery.of(this).size.height;
  double screenWidth() => MediaQuery.of(this).size.width;
}
getDate(double day) {
  final date = DateTime.now();
  DateTime dateTime = date.subtract(Duration(days: day.toInt()));
  return '${dateTime.day}/${dateTime.month}';
}