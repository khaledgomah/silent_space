

import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitState());
  bool isRunning = false;
  triggerTimer() {
    if (isRunning) {
      emit(TimerStopped());
      isRunning = false;
    } else {
      emit(InProgressTimerState());
      isRunning = true;
    }
  }
}
