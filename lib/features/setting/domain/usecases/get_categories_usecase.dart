import 'package:dartz/dartz.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/setting/domain/repositories/settings_repository.dart';

class GetCategoriesUseCase extends UseCase<List<String>, NoParams> {
  GetCategoriesUseCase(this.repository);
  final SettingsRepository repository;

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
