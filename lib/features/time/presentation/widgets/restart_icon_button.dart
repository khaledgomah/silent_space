// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/widgets/custom_icon_button.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';

class RestartTimerIconButton extends StatelessWidget {
  const RestartTimerIconButton({
    super.key,
    required this.countDownController,
  });
  final CountDownController countDownController;
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      tooltip: 'Restart',
      onPressed: () {
        countDownController.restart(
          duration: context.read<TimerCubit>().durationTime * 60,
        );
        if (context.read<TimerCubit>().state.status != TimerStatus.inProgress) {
          countDownController.pause();
        }
      },
      icon: const Icon(Icons.restart_alt),
    );
  }
}
