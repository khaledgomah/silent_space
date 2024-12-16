import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:silent_space/core/utils/sounds_manager.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitState());
  bool isRunning = false;
  final player = AudioPlayer();
  String path = SoundsManager.none;
  _playSound() async {
    if (path != SoundsManager.none) {
      await player.setAsset(path);
      await player.setLoopMode(LoopMode.all);
      await player.play();
    }
  }

  _pauseSound() async {
    await player.pause();
  }

  triggerTimer() {
    if (isRunning) {
      emit(TimerStopped());
      _pauseSound();
      isRunning = false;
    } else {
      emit(InProgressTimerState());
      _playSound();
      isRunning = true;
    }
  }
}
