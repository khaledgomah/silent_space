import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  void push(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  void pushNamed(String routeName) {
    Navigator.pushNamed(this, routeName);
  }
  void pushAndReplacement(Widget page) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void pop() {
    Navigator.pop(this);
  }
}
