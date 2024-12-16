import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/constans.dart';

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
      strokeWidth: Constants.circleThikness,
      controller: _countDownController,
      autoStart: false,
      isReverse: true,
      duration: maxTime,
      width: context.width() * 0.8,
      height: context.height() * 0.5,
      fillColor: Colors.white,
      ringColor: Colors.grey.shade800,
      textFormat: 'mm:ss',
      textStyle: const TextStyle(fontSize: 48, color: Colors.white),
    );
  }
}