import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/errors/failure_mapper.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/setting/domain/usecases/get_categories_usecase.dart';
import 'package:silent_space/features/setting/domain/usecases/save_categories_usecase.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
    required SaveCategoriesUseCase saveCategoriesUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _saveCategoriesUseCase = saveCategoriesUseCase,
        super(SettingsInitial());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final SaveCategoriesUseCase _saveCategoriesUseCase;

  Future<void> loadCategories() async {
    emit(SettingsLoading());
    final result = await _getCategoriesUseCase(NoParams());
    result.fold(
      (failure) => emit(SettingsError(message: FailureMapper.map(failure))),
      (categories) {
        if (categories.isEmpty) {
          final defaultCategories = ['Focus', 'Relax', 'Sleep', 'Meditation', 'Study', 'Workout', 'Yoga', 'Kids'];
          saveCategories(defaultCategories);
        } else {
          emit(SettingsLoaded(categories: categories));
        }
      },
    );
  }

  Future<void> saveCategories(List<String> categories) async {
    emit(SettingsLoading());
    final result = await _saveCategoriesUseCase(categories);
    result.fold(
      (failure) => emit(SettingsError(message: FailureMapper.map(failure))),
      (_) => emit(SettingsLoaded(categories: categories)),
    );
  }

  Future<void> addCategory(String category) async {
    if (state is SettingsLoaded) {
      final currentCategories = List<String>.from((state as SettingsLoaded).categories);
      if (!currentCategories.contains(category)) {
        currentCategories.add(category);
        await saveCategories(currentCategories);
      }
    }
  }

  Future<void> removeCategory(String category) async {
    if (state is SettingsLoaded) {
      final currentCategories = List<String>.from((state as SettingsLoaded).categories);
      currentCategories.remove(category);
      await saveCategories(currentCategories);
    }
  }
}
