part of 'timer_cubit.dart';

enum TimerStatus { initial, inProgress, stopped }

class TimerState extends Equatable {
  const TimerState({
    this.status = TimerStatus.initial,
    this.durationTime = 25,
    this.breakTime = 5,
    this.voiceLevel = 50,
    this.path = '',
  });
  final TimerStatus status;
  final int durationTime;
  /// TODO: Implement Pomodoro break cycle - currently stored but unused
  final int breakTime;
  final int voiceLevel;
  final String path;

  TimerState copyWith({
    TimerStatus? status,
    int? durationTime,
    int? breakTime,
    int? voiceLevel,
    String? path,
  }) {
    return TimerState(
      status: status ?? this.status,
      durationTime: durationTime ?? this.durationTime,
      breakTime: breakTime ?? this.breakTime,
      voiceLevel: voiceLevel ?? this.voiceLevel,
      path: path ?? this.path,
    );
  }

  @override
  List<Object?> get props => [
        status,
        durationTime,
        breakTime,
        voiceLevel,
        path,
      ];
}
