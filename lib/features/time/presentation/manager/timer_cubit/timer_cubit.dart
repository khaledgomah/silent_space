import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/core/utils/sounds_manager.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:uuid/uuid.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit()
      : _prefs = getIt<SharedPreferences>(),
        super(TimerState(
          durationTime: getIt<SharedPreferences>().getInt('focusTime') ?? 25,
          breakTime: getIt<SharedPreferences>().getInt('breakTime') ?? 5,
          voiceLevel: getIt<SharedPreferences>().getInt('voiceLevel') ?? 50,
          path: getIt<SharedPreferences>().getString('soundPath') ?? SoundsManager.none,
        )) {
    player = AudioPlayer();
  }
  late final AudioPlayer player;
  final SharedPreferences _prefs;

  @override
  Future<void> close() {
    player.dispose();
    return super.close();
  }

  // ── Getters ──
  int get breakTime => state.breakTime;
  int get durationTime => state.durationTime;
  int get voiceLevel => state.voiceLevel;
  String get path => state.path;

  // ── Setters ──
  void setBreakTime(int value) {
    _prefs.setInt('breakTime', value);
    emit(state.copyWith(breakTime: value));
  }

  void setVoiceLevel(int value) {
    player.setVolume(value / 100);
    _prefs.setInt('voiceLevel', value);
    emit(state.copyWith(voiceLevel: value));
  }

  void setDurationTime(int value) {
    _prefs.setInt('focusTime', value);
    emit(state.copyWith(durationTime: value));
  }

  void setPath(String value) {
    _prefs.setString('soundPath', value);
    emit(state.copyWith(path: value));
  }

  Future<void> _playSound() async {
    if (state.path != SoundsManager.none && state.path.isNotEmpty) {
      await player.setAsset(state.path);
      await player.setLoopMode(LoopMode.all);
      await player.play();
      player.setVolume(state.voiceLevel / 100);
    }
  }

  Future<void> _pauseSound() async {
    await player.pause();
  }

  void triggerTimer() {
    if (state.status == TimerStatus.inProgress) {
      emit(state.copyWith(status: TimerStatus.stopped));
      _pauseSound();
    } else {
      emit(state.copyWith(status: TimerStatus.inProgress));
      _playSound();
    }
  }

  /// Called when the timer naturally finishes
  void completeSession(SessionCubit sessionCubit) {
    emit(state.copyWith(status: TimerStatus.stopped));
    _pauseSound();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Should ideally be logged in

    final session = FocusSession(
      id: const Uuid().v4(),
      userId: user.uid,
      startTime: DateTime.now().subtract(Duration(minutes: state.durationTime)),
      endTime: DateTime.now(),
      durationInSeconds: state.durationTime * 60,
      category: 'Focus', // Default category
    );

    sessionCubit.saveSession(session);
  }
}
