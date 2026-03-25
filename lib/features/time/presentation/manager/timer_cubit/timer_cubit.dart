import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/core/utils/sounds_manager.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitState());
  bool isRunning = false;
  final player = AudioPlayer();
  int _durationTime =
      getIt<SharedPreferences>().getInt('focusTime') ?? 25;
  int _breakTime = getIt<SharedPreferences>().getInt('breakTime') ?? 5;

//breakTime getter and setter
  int get breakTime => _breakTime;
  set breakTime(int value) {
    _breakTime = value;
    getIt<SharedPreferences>().setInt('breakTime', value);
  }

  int _voiceLevel =
      getIt<SharedPreferences>().getInt('voiceLevel') ?? 50;
  String _path = SoundsManager.none;

  //soundLevel getter and setter
  int get voiceLevel => _voiceLevel;
  set voiceLevel(int value) {
    _voiceLevel = value;
    player.setVolume(_voiceLevel / 100);
    getIt<SharedPreferences>().setInt('voiceLevel', value);
  }

  //durationTime getter and setter
  int get durationTime => _durationTime;
  set durationTime(int value) {
    _durationTime = value;
    getIt<SharedPreferences>().setInt('focusTime', value);
  }

//path getter and setter
  String get path => _path;
  set path(String value) {
    _path = value;
    getIt<SharedPreferences>().setString('soundPath', value);
  }

  Future<void> _playSound() async {
    if (path != SoundsManager.none) {
      await player.setAsset(path);
      await player.setLoopMode(LoopMode.all);
      await player.play();
      player.setVolume(voiceLevel / 100);
    }
  }

  Future<void> _pauseSound() async {
    await player.pause();
  }

  void triggerTimer() {
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
