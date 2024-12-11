
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sharedPreferences()async
{
final SharedPreferencesWithCache prefsWithCache =
    await SharedPreferencesWithCache.create(
  cacheOptions: const SharedPreferencesWithCacheOptions(
    allowList: <String>{'maxTime'},
  ),
);prefsWithCache.setInt('maxTime', 30);
final int? maxTime = prefsWithCache.getInt('maxTime');
log(maxTime.toString());
await prefsWithCache.clear();

}