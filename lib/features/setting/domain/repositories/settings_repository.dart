import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, void>> saveCategories(List<String> categories);
}
