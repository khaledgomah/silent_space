import 'package:flutter/material.dart';

extension MediaQuerySize on BuildContext {
  double height() => MediaQuery.of(this).size.height;
  double width() => MediaQuery.of(this).size.width;
}


getDate(double day) {
  final date = DateTime.now();
  DateTime dateTime = date.subtract(Duration(days: day.toInt()));
  return '${dateTime.day}/${dateTime.month}';
}

void showSnackBar(BuildContext context, String message,{int duration = 2}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration:  Duration(seconds: duration),
  ));
}
