import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:silent_space/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:silent_space/features/auth/presentation/pages/forgot_password_page.dart';

class MockForgotPasswordCubit extends Mock implements ForgotPasswordCubit {}

void main() {
  late MockForgotPasswordCubit mockCubit;

  setUp(() {
    mockCubit = MockForgotPasswordCubit();
    // Register mock cubit in GetIt
    GetIt.instance.registerFactory<ForgotPasswordCubit>(() => mockCubit);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: widget,
    );
  }

  testWidgets('ForgotPasswordPage displays UI elements successfully',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(ForgotPasswordInitial());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.close()).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget(const ForgotPasswordPage()));
    await tester.pump();

    // Verify email field logic exists via keys or types (since text is localized)
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
