import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/features/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:silent_space/features/forgot_password/presentation/cubit/forgot_password_state.dart';
import 'package:silent_space/features/forgot_password/presentation/pages/reset_password_page.dart';

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

  testWidgets('ResetPasswordPage displays UI elements successfully', (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(ForgotPasswordInitial());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.close()).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget(const ResetPasswordPage(token: 'dummy_token')));
    await tester.pump();

    // Verify fields by type instead of localized text
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
