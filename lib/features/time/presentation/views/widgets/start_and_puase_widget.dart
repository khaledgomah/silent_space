// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/widgets/custom_icon_button.dart';
import 'package:silent_space/features/time/presentation/manager/cubit/timer_cubit.dart';

class StartAndPuaseWidget extends StatelessWidget {
  const StartAndPuaseWidget({super.key, required this.countDownController});
  final CountDownController countDownController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        if (state is TimerInitState) {
          return CustomIconButton(
            onPressed: () {
              BlocProvider.of<TimerCubit>(context).triggerTimer();
              countDownController.start();
            },
            icon: const Icon(Icons.play_arrow),
          );
        }
        if (state is InProgressTimerState) {
          return CustomIconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {
              BlocProvider.of<TimerCubit>(context).triggerTimer();
              countDownController.pause();
            },
          );
        } else {
          return CustomIconButton(
            onPressed: () {
              BlocProvider.of<TimerCubit>(context).triggerTimer();
              countDownController.resume();
            },
            icon: const Icon(Icons.play_arrow),
          );
        }
      },
    );
  }
}
