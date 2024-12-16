import 'dart:developer';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/widgets/custom_icon_button.dart';
import 'package:silent_space/features/home/presentation/manager/cubit/timer_cubit.dart';
import 'package:just_audio/just_audio.dart';

class StartAndPuaseWidget extends StatelessWidget {
  const StartAndPuaseWidget({super.key, required this.countDownController});
  final CountDownController countDownController;

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        if (state is TimerInitState) {
          return CustomIconButton(
            onPressed: () async {
              countDownController.start();
              await player.setLoopMode(LoopMode.all);

              if (!context.mounted) return;
              BlocProvider.of<TimerCubit>(context).triggerTimer();
            },
            icon: const Icon(Icons.play_arrow),
          );
        }
        if (state is InProgressTimerState) {
          return CustomIconButton(
            icon: const Icon(Icons.pause),
            onPressed: () async {
              BlocProvider.of<TimerCubit>(context).triggerTimer();
              countDownController.pause();
            },
          );
        } else {
          return CustomIconButton(
            onPressed: () async {
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
