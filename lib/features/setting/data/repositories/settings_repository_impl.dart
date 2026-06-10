import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/features/setting/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._prefs);
  final SharedPreferences _prefs;

  static const _categoriesKey = 'categories';

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = _prefs.getStringList(_categoriesKey) ?? [];
      return Right(categories);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to retrieve categories: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCategories(List<String> categories) async {
    try {
      await _prefs.setStringList(_categoriesKey, categories);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save categories: $e'));
    }
  }
}
