import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> locatorSetup() async {
  final sharedPreferencesWithCache = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{'language','voiceLevel','focusTime','breakTime','sound'},
    ),
  );
  getIt.registerSingleton<SharedPreferencesWithCache>(
      sharedPreferencesWithCache);
}

