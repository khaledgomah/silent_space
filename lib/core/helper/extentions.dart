import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  void navigateTo(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void navigateToReplacement(Widget page) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void navigateBack() {
    Navigator.pop(this);
  }
}