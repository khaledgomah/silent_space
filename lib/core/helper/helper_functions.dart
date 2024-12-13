import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

extension MediaQuerySize on BuildContext {
  double height() => MediaQuery.of(this).size.height;
  double width() => MediaQuery.of(this).size.width;
}
  GetIt getIt = GetIt.instance;

getDate(double day) {
  final date = DateTime.now();
  DateTime dateTime = date.subtract(Duration(days: day.toInt()));
  return '${dateTime.day}/${dateTime.month}';
}


