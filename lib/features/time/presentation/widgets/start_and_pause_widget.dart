import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/widgets/custom_icon_button.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';

class StartAndPauseWidget extends StatelessWidget {
  const StartAndPauseWidget({super.key, required this.countDownController});
  final CountDownController countDownController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        if (state.status == TimerStatus.initial) {
          return CustomIconButton(
            onPressed: () async {
              countDownController.start();

              if (!context.mounted) return;
              BlocProvider.of<TimerCubit>(context).triggerTimer();
            },
            icon: const Icon(Icons.play_arrow),
          );
        }
        if (state.status == TimerStatus.inProgress) {
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
