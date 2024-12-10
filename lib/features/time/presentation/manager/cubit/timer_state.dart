part of 'timer_cubit.dart';

@immutable
sealed class TimerState {}

final class TimerInitState extends TimerState {}

final class InProgressTimerState extends TimerState {}

final class TimerStopped extends TimerState {}
