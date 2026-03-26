import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/features/auth/domain/entities/user_entity.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/home/presentation/widgets/focus_chart.dart';
import 'package:silent_space/features/home/presentation/widgets/show_details.dart';
import 'package:silent_space/features/home/presentation/widgets/states_screen.dart';
import 'package:silent_space/features/session/domain/entities/focus_session.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/session/presentation/cubit/session_state.dart';

// Mock Cubits
class MockSessionCubit extends Mock implements SessionCubit {}
class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockSessionCubit mockSessionCubit;
  late MockAuthCubit mockAuthCubit;

  setUpAll(() async {
    EasyLocalization.logger.enableLevels = [];
  });

  setUp(() {
    mockSessionCubit = MockSessionCubit();
    mockAuthCubit = MockAuthCubit();

    // Session Cubit defaults
    when(() => mockSessionCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSessionCubit.close()).thenAnswer((_) async {});
    when(() => mockSessionCubit.loadSessions(
          userId: any(named: 'userId'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
        )).thenAnswer((_) async {});

    // Auth Cubit defaults (Simulate logged in user)
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthCubit.close()).thenAnswer((_) async {});
    when(() => mockAuthCubit.state).thenReturn(const AuthSuccess(
      user: UserEntity(id: 'user123', email: 'test@me.com', token: 'token'),
    ));
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<SessionCubit>.value(value: mockSessionCubit),
            BlocProvider<AuthCubit>.value(value: mockAuthCubit),
          ],
          child: const StatesScreen(),
        ),
      ),
    );
  }

  group('StatesScreen States', () {
    testWidgets('shows loading indicator when state is SessionLoading',
        (tester) async {
      when(() => mockSessionCubit.state).thenReturn(const SessionLoading());

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'shows empty query stats icon when SessionLoaded with empty sessions',
        (tester) async {
      when(() => mockSessionCubit.state)
          .thenReturn(const SessionLoaded([]));

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byIcon(Icons.query_stats), findsOneWidget);
    });

    testWidgets(
        'shows data (two ShowDetails and one FocusChart) when SessionLoaded with data',
        (tester) async {
      final now = DateTime.now();
      final tSessions = [
        FocusSession(
          id: '1',
          userId: 'user123',
          startTime: now.subtract(const Duration(minutes: 30)),
          endTime: now,
          durationInSeconds: 30 * 60,
          category: 'Focus',
        ),
      ];
      final loadedState = SessionLoaded(tSessions);

      when(() => mockSessionCubit.state).thenReturn(loadedState);

      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ShowDetails), findsNWidgets(2));
      expect(find.byType(FocusChart), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('shows RefreshIndicator across different states', (tester) async {
      // 1. Loaded Empty
      when(() => mockSessionCubit.state)
          .thenReturn(const SessionLoaded([]));
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(RefreshIndicator), findsOneWidget);

      // 2. Error
      when(() => mockSessionCubit.state)
          .thenReturn(const SessionError(message: 'error'));
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('pulling RefreshIndicator triggers loadSessions', (tester) async {
      when(() => mockSessionCubit.state)
          .thenReturn(const SessionLoaded([]));

      await tester.pumpWidget(buildTestableWidget());

      await tester.drag(find.byType(RefreshIndicator), const Offset(0.0, 300.0));
      await tester.pumpAndSettle();

      verify(() => mockSessionCubit.loadSessions(
            userId: 'user123',
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          )).called(1);
    });

    group('StatesScreen Auth Handling', () {
      testWidgets('should not load sessions if user is not logged in',
          (tester) async {
        when(() => mockAuthCubit.state).thenReturn(AuthInitial());
        when(() => mockSessionCubit.state).thenReturn(const SessionInitial());

        await tester.pumpWidget(buildTestableWidget());

        verifyNever(() => mockSessionCubit.loadSessions(
              userId: any(named: 'userId'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
            ));
      });
    });
  });
}
