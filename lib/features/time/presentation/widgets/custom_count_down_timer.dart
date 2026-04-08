import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/notifications/notification_service.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/constants.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';

class CustomCountDownTimer extends StatelessWidget {
  const CustomCountDownTimer({
    super.key,
    required CountDownController countDownController,
  }) : _countDownController = countDownController;

  final CountDownController _countDownController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        final maxTime = state.durationTime * 60;
        final theme = Theme.of(context);

        return CircularCountDownTimer(
          strokeWidth: Constants.circleThickness,
          controller: _countDownController,
          autoStart: false,
          isReverse: true,
          duration: maxTime,
          width: context.width() * 0.8,
          height: context.height() * 0.5,
          fillColor: theme.colorScheme.primary,
          ringColor: theme.colorScheme.surfaceContainerHighest,
          textFormat: maxTime >= 3600 ? 'hh:mm:ss' : 'mm:ss',
          textStyle: TextStyle(
            fontSize: 48,
            color: theme.colorScheme.onSurface,
          ),
          onComplete: () {
            try {
              NotificationService().showNotification(
                id: 0,
                title: AppStrings.timesUp.tr(),
                body: AppStrings.focusSessionComplete.tr(),
              );
            } catch (_) {
              // Silently handle notification failure
            }
            context.read<TimerCubit>().completeSession(context.read<SessionCubit>());
          },
        );
      },
    );
  }
}
