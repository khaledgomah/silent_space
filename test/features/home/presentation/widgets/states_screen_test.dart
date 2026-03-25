import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/features/home/presentation/widgets/focus_chart.dart';
import 'package:silent_space/features/home/presentation/widgets/show_details.dart';
import 'package:silent_space/features/home/presentation/widgets/states_screen.dart';
import 'package:silent_space/features/session/domain/entities/session_entity.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';
import 'package:silent_space/features/session/presentation/cubit/session_state.dart';

// Mock Cubit using mocktail since bloc_test is not available
class MockSessionCubit extends Mock implements SessionCubit {}

void main() {
  late MockSessionCubit mockSessionCubit;

  setUpAll(() async {
    // Disable Easy Localization logging in tests to keep output clean.
    EasyLocalization.logger.enableLevels = [];
  });

  setUp(() {
    mockSessionCubit = MockSessionCubit();
    // Provide a dummy stream and state for Cubit to avoid errors with BlocBuilder
    when(() => mockSessionCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSessionCubit.close()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<SessionCubit>.value(
          value: mockSessionCubit,
          child: const StatesScreen(),
        ),
      ),
    );
  }

  testWidgets('shows loading indicator when state is SessionLoading',
      (tester) async {
    when(() => mockSessionCubit.state).thenReturn(SessionLoading());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'shows empty query stats icon when SessionLoaded with empty sessions',
      (tester) async {
    when(() => mockSessionCubit.state)
        .thenReturn(SessionLoaded(sessions: const []));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byIcon(Icons.query_stats), findsOneWidget);
  });

  testWidgets(
      'shows data (two ShowDetails and one FocusChart) when SessionLoaded with data',
      (tester) async {
    final now = DateTime.now();
    final tSessions = [
      SessionEntity(
        id: '1',
        startTime: now.subtract(const Duration(minutes: 30)),
        durationMinutes: 30,
        completedAt: now,
      ),
    ];
    final loadedState = SessionLoaded(sessions: tSessions);

    when(() => mockSessionCubit.state).thenReturn(loadedState);

    // Provide physical size to avoid overflow issues in charts during testing
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(buildTestableWidget());

    // Allow translations/render to happen
    await tester.pumpAndSettle();

    expect(find.byType(ShowDetails), findsNWidgets(2)); // Today and All-time
    expect(find.byType(FocusChart), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });
}
