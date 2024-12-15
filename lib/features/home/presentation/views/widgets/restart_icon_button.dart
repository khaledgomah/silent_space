// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/widgets/custom_icon_button.dart';
import 'package:silent_space/features/home/presentation/manager/cubit/timer_cubit.dart';

class RestTimerIconButton extends StatelessWidget {
  const RestTimerIconButton({
    super.key,
    required this.countDownController,
    required this.maxTime,
  });
  final CountDownController countDownController;
  final int maxTime;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerCubit(),
      child: CustomIconButton(
        onPressed: () {
          countDownController.restart(duration: maxTime);
          if (BlocProvider.of<TimerCubit>(context).isRunning == false) {
            countDownController.pause();
          }
        },
        icon: const Icon(Icons.restart_alt),
      ),
    );
  }
}
