import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/setting/domain/repositories/settings_repository.dart';

class SaveCategoriesUseCase extends UseCase<void, List<String>> {
  SaveCategoriesUseCase(this.repository);
  final SettingsRepository repository;

  @override
  Future<Either<Failure, void>> call(List<String> params) async {
    return await repository.saveCategories(params);
  }
}
