import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSessionCubit extends Mock implements SessionCubit {}

void main() {
  late TimerCubit cubit;
  late MockAudioPlayer mockAudioPlayer;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    registerFallbackValue(LoopMode.all);
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    mockAudioPlayer = MockAudioPlayer();
    mockSharedPreferences = MockSharedPreferences();

    // Stub SharedPreferences calls
    when(() => mockSharedPreferences.getInt('focusTime')).thenReturn(25);
    when(() => mockSharedPreferences.getInt('breakTime')).thenReturn(5);
    when(() => mockSharedPreferences.getInt('voiceLevel')).thenReturn(50);
    when(() => mockSharedPreferences.getString('soundPath'))
        .thenReturn('assets/sounds/ambient.mp3');

    // Stub AudioPlayer calls
    when(() => mockAudioPlayer.setVolume(any())).thenAnswer((_) async {});
    when(() => mockAudioPlayer.setAsset(
          any(),
          package: any(named: 'package'),
          preload: any(named: 'preload'),
          initialPosition: any(named: 'initialPosition'),
          tag: any(named: 'tag'),
        )).thenAnswer((_) async => Duration.zero);
    when(() => mockAudioPlayer.setLoopMode(any())).thenAnswer((_) async {});
    when(() => mockAudioPlayer.play()).thenAnswer((_) async {});
    when(() => mockAudioPlayer.pause()).thenAnswer((_) async {});
    when(() => mockAudioPlayer.dispose()).thenAnswer((_) async {});

    cubit = TimerCubit(
      prefs: mockSharedPreferences,
      player: mockAudioPlayer,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('TimerCubit', () {
    test('initial state should reflect SharedPreferences values', () {
      expect(cubit.state.durationTime, equals(25));
      expect(cubit.state.voiceLevel, equals(50));
      expect(cubit.state.path, equals('assets/sounds/ambient.mp3'));
      expect(cubit.state.status, equals(TimerStatus.initial));
    });

    test('diagnostic - setAsset mock behavior', () async {
      try {
        final res = await mockAudioPlayer.setAsset('assets/sounds/ambient.mp3');
        log('DIAGNOSTIC RES: $res');
      } catch (e, stack) {
        log('DIAGNOSTIC ERR: $e');
        log('DIAGNOSTIC STACK: $stack');
      }
    });

    test('setVoiceLevel - should update state and save to SharedPreferences', () {
      when(() => mockSharedPreferences.setInt('voiceLevel', 80)).thenAnswer((_) async => true);

      cubit.setVoiceLevel(80);

      expect(cubit.state.voiceLevel, equals(80));
      verify(() => mockSharedPreferences.setInt('voiceLevel', 80)).called(1);
      verify(() => mockAudioPlayer.setVolume(0.8)).called(1);
    });

    test('setDurationTime - should update state and save to SharedPreferences', () {
      when(() => mockSharedPreferences.setInt('focusTime', 30)).thenAnswer((_) async => true);

      cubit.setDurationTime(30);

      expect(cubit.state.durationTime, equals(30));
      verify(() => mockSharedPreferences.setInt('focusTime', 30)).called(1);
    });

    test('setPath - should update state and save to SharedPreferences', () {
      when(() => mockSharedPreferences.setString('soundPath', 'path/to/sound'))
          .thenAnswer((_) async => true);

      cubit.setPath('path/to/sound');

      expect(cubit.state.path, equals('path/to/sound'));
      verify(() => mockSharedPreferences.setString('soundPath', 'path/to/sound')).called(1);
    });

    test('triggerTimer - from stopped to inProgress should play sound and update status', () async {
      final expected = [
        cubit.state.copyWith(status: TimerStatus.inProgress),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      cubit.triggerTimer();
      await Future.delayed(const Duration(milliseconds: 10));

      verify(() => mockAudioPlayer.setAsset(any())).called(1);
      verify(() => mockAudioPlayer.setLoopMode(any())).called(1);
      verify(() => mockAudioPlayer.setVolume(any())).called(1);
      verify(() => mockAudioPlayer.play()).called(1);
    });

    test('triggerTimer - from inProgress to stopped should pause sound and update status',
        () async {
      // Set to inProgress first
      final expected = [
        cubit.state.copyWith(status: TimerStatus.inProgress),
        cubit.state.copyWith(status: TimerStatus.stopped),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      cubit.triggerTimer(); // stops -> starts
      cubit.triggerTimer(); // starts -> stops

      verify(() => mockAudioPlayer.pause()).called(1);
    });
  });
}
