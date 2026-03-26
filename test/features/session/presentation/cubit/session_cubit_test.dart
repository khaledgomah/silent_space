import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import 'package:silent_space/features/session/domain/usecases/get_sessions_by_date_range_usecase.dart';
import 'package:silent_space/features/session/domain/usecases/save_session_usecase.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/session/presentation/cubit/session_state.dart';

class MockGetSessionsByDateRangeUseCase extends Mock
    implements GetSessionsByDateRangeUseCase {}

class MockSaveSessionUseCase extends Mock implements SaveSessionUseCase {}

class FakeGetSessionsByDateRangeParams extends Fake
    implements GetSessionsByDateRangeParams {}

class FakeFocusSession extends Fake implements FocusSession {}

void main() {
  late SessionCubit cubit;
  late MockGetSessionsByDateRangeUseCase mockGetSessionsByDateRangeUseCase;
  late MockSaveSessionUseCase mockSaveSessionUseCase;

  setUpAll(() {
    registerFallbackValue(FakeGetSessionsByDateRangeParams());
    registerFallbackValue(FakeFocusSession());
  });

  setUp(() {
    mockGetSessionsByDateRangeUseCase = MockGetSessionsByDateRangeUseCase();
    mockSaveSessionUseCase = MockSaveSessionUseCase();
    cubit = SessionCubit(
      getSessionsByDateRangeUseCase: mockGetSessionsByDateRangeUseCase,
      saveSessionUseCase: mockSaveSessionUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final now = DateTime.now();
  final tSessions = [
    FocusSession(
      id: '1',
      userId: 'user123',
      startTime: now.subtract(const Duration(minutes: 30)),
      endTime: now,
      durationInSeconds: 30 * 60,
      category: 'Work',
    ),
    FocusSession(
      id: '2',
      userId: 'user123',
      startTime: now.subtract(const Duration(days: 1)),
      endTime: now.subtract(const Duration(days: 1, minutes: -45)),
      durationInSeconds: 45 * 60,
      category: 'Study',
    ),
  ];

  group('loadSessions', () {
    test('initial state should be SessionInitial', () {
      expect(cubit.state, equals(const SessionInitial()));
    });

    test('should emit [SessionLoading, SessionLoaded] when successful',
        () async {
      // arrange
      when(() => mockGetSessionsByDateRangeUseCase(any()))
          .thenAnswer((_) async => Right(tSessions));

      // assert later
      final expected = [
        const SessionLoading(),
        SessionLoaded(tSessions),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      // act
      await cubit.loadSessions(
        userId: 'user123',
        startTime: now,
        endTime: now,
      );
    });

    test('should emit SessionLoaded with empty list when no sessions exist',
        () async {
      when(() => mockGetSessionsByDateRangeUseCase(any()))
          .thenAnswer((_) async => const Right([]));

      final expected = [
        const SessionLoading(),
        const SessionLoaded([]),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadSessions(
        userId: 'user123',
        startTime: now,
        endTime: now,
      );
    });

    test('should emit [SessionLoading, SessionError] when failure occurs',
        () async {
      when(() => mockGetSessionsByDateRangeUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Error')));

      final expected = [
        const SessionLoading(),
        const SessionError(message: 'Server Error'),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadSessions(
        userId: 'user123',
        startTime: now,
        endTime: now,
      );
    });
  });

  group('saveSession', () {
    test('should call saveSessionUseCase and not emit error if successful',
        () async {
      when(() => mockSaveSessionUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      await cubit.saveSession(tSessions.first);

      verify(() => mockSaveSessionUseCase(tSessions.first)).called(1);
      expect(cubit.state, const SessionInitial());
    });

    test('should emit SessionError when failing to save', () async {
      when(() => mockSaveSessionUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Save Error')));

      final expected = [
        const SessionError(message: 'Save Error'),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.saveSession(tSessions.first);
    });
  });
}
