import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';

void main() {
  runApp(const SilentSpace());
}

class SilentSpace extends StatelessWidget {
  const SilentSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RoutesName.splash,
      onGenerateRoute: onGenerateRoute,
      theme:
          ThemeData(primaryColor: Colors.green, brightness: Brightness.light),
    );
  }
}
