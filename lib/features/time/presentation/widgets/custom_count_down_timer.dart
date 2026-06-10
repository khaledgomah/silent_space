import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/notifications/notification_service.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/constants.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';

class CustomCountDownTimer extends StatefulWidget {
  const CustomCountDownTimer({
    super.key,
    required this.countDownController,
  });

  final CountDownController countDownController;

  @override
  State<CustomCountDownTimer> createState() => _CustomCountDownTimerState();
}

class _CustomCountDownTimerState extends State<CustomCountDownTimer>
    with WidgetsBindingObserver {
  int _remainingSeconds = 0;
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    final timerStatus = context.read<TimerCubit>().state.status;
    if (timerStatus == TimerStatus.inProgress) {
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive) {
        _pausedAt = DateTime.now();
      } else if (state == AppLifecycleState.resumed) {
        if (_pausedAt != null) {
          final elapsed = DateTime.now().difference(_pausedAt!).inSeconds;
          _pausedAt = null;
          final newRemaining = _remainingSeconds - elapsed;

          if (newRemaining <= 0) {
            _triggerCompletion();
          } else {
            _remainingSeconds = newRemaining;
            widget.countDownController.restart(duration: newRemaining);
          }
        }
      }
    }
  }

  void _triggerCompletion() {
    try {
      NotificationService().showNotification(
        id: 0,
        title: AppStrings.timesUp.tr(),
        body: AppStrings.focusSessionComplete.tr(),
      );
    } catch (_) {
      // Silently handle notification failure
    }
    final authState = context.read<AuthCubit>().state;
    String userId = '';
    if (authState is AuthSuccess) {
      userId = authState.user.id ?? '';
    }
    context.read<TimerCubit>().completeSession(
          sessionCubit: context.read<SessionCubit>(),
          userId: userId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        final maxTime = state.durationTime * 60;
        final theme = Theme.of(context);

        if (_remainingSeconds == 0 && state.status == TimerStatus.initial) {
          _remainingSeconds = maxTime;
        }

        return CircularCountDownTimer(
          strokeWidth: Constants.circleThickness,
          controller: widget.countDownController,
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
          onChange: (String timeStamp) {
            _remainingSeconds = int.tryParse(timeStamp) ?? 0;
          },
          onComplete: _triggerCompletion,
        );
      },
    );
  }
}
