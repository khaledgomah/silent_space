// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class CustomCountDownTimer extends StatelessWidget {
  const CustomCountDownTimer({
    super.key,
    required CountDownController countDownController,
    required this.maxTime,
  }) : _countDownController = countDownController;

  final CountDownController _countDownController;
  final int maxTime;

  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
      controller: _countDownController,
      autoStart: false,
      isReverse: true,
      duration: maxTime,
      width: 200,
      height: 200,
      fillColor: Colors.grey,
      ringColor: Colors.white,
      isReverseAnimation: true,
      textStyle: const TextStyle(fontSize: 48),
    );
  }
}
