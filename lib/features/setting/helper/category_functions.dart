import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferencesWithCache>
    getsharedPreferencesCategoriesObject() async {
  final sharedPreferencesWithCache = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{'categories'},
    ),
  );
  return sharedPreferencesWithCache;
}

Future<void> saveCategories(List<String> categories) async {
  final sharedPreferencesWithCache =
      await getsharedPreferencesCategoriesObject();
  sharedPreferencesWithCache.setStringList('categories', categories);
}

Future<List<String>> getCategeories() async {
  final sharedPreferencesWithCache =
      await getsharedPreferencesCategoriesObject();

  return sharedPreferencesWithCache.getStringList('categories') ?? [];
}


