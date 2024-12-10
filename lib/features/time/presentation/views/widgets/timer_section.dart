import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:silent_space/features/time/presentation/views/widgets/custom_count_down_timer.dart';
import 'package:silent_space/features/time/presentation/views/widgets/restart_icon_button.dart';
import 'package:silent_space/features/time/presentation/views/widgets/start_and_puase_widget.dart';

class TimerSection extends StatelessWidget {
  const TimerSection({
    super.key,
    required CountDownController countDownController,
    required this.maxTime,
  }) : _countDownController = countDownController;

  final CountDownController _countDownController;
  final int maxTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomCountDownTimer(countDownController: _countDownController, maxTime: maxTime),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StartAndPuaseWidget(
              countDownController: _countDownController,
            ),
            const SizedBox(
              width: 20,
            ),
            RestartIconButton(
              countDownController: _countDownController,
              maxTime: maxTime,
            )
          ],
        ),
      ],
    );
  }
}

