import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpLocalizedApp(
  WidgetTester tester, {
  required Widget child,
  Locale locale = const Locale('en'),
}) async {
  // Wrapping test widgets with localization keeps tests aligned with runtime
  // configuration and prevents false positives from hardcoded text assumptions.
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: locale,
      child: MaterialApp(home: child),
    ),
  );

  await tester.pumpAndSettle();
}
