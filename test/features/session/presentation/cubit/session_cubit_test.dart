import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';
import 'package:silent_space/features/session/domain/usecases/get_sessions_usecase.dart';
import 'package:silent_space/features/session/domain/usecases/save_session_usecase.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/session/presentation/cubit/session_state.dart';

class MockGetSessionsUseCase extends Mock implements GetSessionsUseCase {}

class MockSaveSessionUseCase extends Mock implements SaveSessionUseCase {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late SessionCubit cubit;
  late MockGetSessionsUseCase mockGetSessionsUseCase;
  late MockSaveSessionUseCase mockSaveSessionUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetSessionsUseCase = MockGetSessionsUseCase();
    mockSaveSessionUseCase = MockSaveSessionUseCase();
    cubit = SessionCubit(
      getSessionsUseCase: mockGetSessionsUseCase,
      saveSessionUseCase: mockSaveSessionUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final now = DateTime.now();
  final tSessions = [
    SessionEntity(
      id: '1',
      startTime: now.subtract(const Duration(minutes: 30)),
      durationMinutes: 30,
      completedAt: now,
    ),
    SessionEntity(
      id: '2',
      startTime: now.subtract(const Duration(days: 1)),
      durationMinutes: 45,
      completedAt: now.subtract(const Duration(days: 1)),
    ),
  ];

  group('loadSessions', () {
    test('initial state should be SessionInitial', () {
      expect(cubit.state, equals(SessionInitial()));
    });

    test('should emit [SessionLoading, SessionLoaded] when successful',
        () async {
      // arrange
      when(() => mockGetSessionsUseCase(any()))
          .thenAnswer((_) async => Right(tSessions));

      // assert later
      final expected = [
        SessionLoading(),
        isA<SessionLoaded>()
            .having((s) => s.sessions, 'sessions', tSessions)
            .having((s) => s.totalCount, 'totalCount', 2)
            .having((s) => s.totalMinutes, 'totalMinutes', 75)
            .having((s) => s.todayMinutes, 'todayMinutes', 30),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      // act
      await cubit.loadSessions();
    });

    test('should emit SessionLoaded with empty list when no sessions exist',
        () async {
      when(() => mockGetSessionsUseCase(any()))
          .thenAnswer((_) async => const Right([]));

      final expected = [
        SessionLoading(),
        isA<SessionLoaded>()
            .having((s) => s.sessions, 'sessions', isEmpty)
            .having((s) => s.totalMinutes, 'totalMinutes', 0),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadSessions();
    });

    test('should emit [SessionLoading, SessionError] when failure occurs',
        () async {
      when(() => mockGetSessionsUseCase(any())).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'Cache Error')));

      final expected = [
        SessionLoading(),
        const SessionError(message: 'Cache Error'),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadSessions();
    });
  });

  group('SessionLoaded computed values', () {
    test('should correctly compute today, total, and weekly minutes', () {
      final state = SessionLoaded(sessions: tSessions);

      expect(state.sessions, tSessions);
      expect(state.todayMinutes, 30);
      expect(state.todayCount, 1);
      expect(state.totalMinutes, 75);
      expect(state.totalCount, 2);

      // Verify weekly minutes (index 6 is today, 5 is yesterday)
      expect(state.weeklyMinutes[6], 30);
      expect(state.weeklyMinutes[5], 45);
    });
  });
}
