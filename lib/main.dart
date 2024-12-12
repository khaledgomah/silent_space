import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/generated/l10n.dart';

void main() {
  runApp(const SilentSpace());
}

class SilentSpace extends StatelessWidget {
  const SilentSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.splash,
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
