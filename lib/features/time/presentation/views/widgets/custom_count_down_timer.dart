import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/constans.dart';
import 'package:silent_space/features/time/presentation/views/home_view.dart';

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
      strokeWidth: Constans.circleThikness,
      controller: _countDownController,
      autoStart: false,
      isReverse: true,
      duration: maxTime,
      width: context.screenWidth() * 0.8,
      height: context.screenWidth() * 0.8,
      fillColor: Colors.grey,
      ringColor: Colors.white,
      textFormat: 'mm:ss',
      textStyle: const TextStyle(fontSize: 48),
    );
  }
}