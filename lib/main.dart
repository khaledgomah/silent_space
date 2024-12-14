import 'package:flutter/material.dart';
import 'package:silent_space/app/silent_space.dart';
import 'package:silent_space/core/utils/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
await locatorSetup();
  runApp(const SilentSpace());
}