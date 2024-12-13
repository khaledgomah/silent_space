import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/app/silent_space.dart';
import 'package:silent_space/core/helper/helper_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton<SharedPreferencesWithCache>(
      await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{'language'},
    ),
  ));
  runApp(const SilentSpace());
}
