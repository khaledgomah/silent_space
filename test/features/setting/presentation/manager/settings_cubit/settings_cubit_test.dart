import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silent_space/core/errors/failures.dart';
import 'package:silent_space/core/usecases/usecase.dart';
import 'package:silent_space/features/setting/domain/usecases/get_categories_usecase.dart';
import 'package:silent_space/features/setting/domain/usecases/save_categories_usecase.dart';
import 'package:silent_space/features/setting/presentation/manager/settings_cubit/settings_cubit.dart';

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
class MockSaveCategoriesUseCase extends Mock implements SaveCategoriesUseCase {}

void main() {
  late SettingsCubit cubit;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockSaveCategoriesUseCase mockSaveCategoriesUseCase;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockSaveCategoriesUseCase = MockSaveCategoriesUseCase();
    cubit = SettingsCubit(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      saveCategoriesUseCase: mockSaveCategoriesUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tCategories = ['Work', 'Study'];

  group('SettingsCubit', () {
    test('initial state should be SettingsInitial', () {
      expect(cubit.state, equals(SettingsInitial()));
    });

    test('loadCategories - should emit [SettingsLoading, SettingsLoaded] when successful and not empty', () async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(tCategories));

      final expected = [
        SettingsLoading(),
        SettingsLoaded(categories: tCategories),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadCategories();
    });

    test('loadCategories - should save defaults and emit [SettingsLoading, SettingsLoaded] when categories are empty', () async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => const Right([]));
      when(() => mockSaveCategoriesUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final defaultCategories = ['Focus', 'Relax', 'Sleep', 'Meditation', 'Study', 'Workout', 'Yoga', 'Kids'];
      final expected = [
        SettingsLoading(),
        SettingsLoaded(categories: defaultCategories),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadCategories();

      verify(() => mockSaveCategoriesUseCase(defaultCategories)).called(1);
    });

    test('loadCategories - should emit [SettingsLoading, SettingsError] when load fails', () async {
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => const Left(CacheFailure(message: 'Cache Load Error')));

      final expected = [
        SettingsLoading(),
        const SettingsError(message: 'unknownError'),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadCategories();
    });

    test('addCategory - should append category and save', () async {
      // Mock initial load
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(tCategories));
      when(() => mockSaveCategoriesUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      await cubit.loadCategories();

      final expected = [
        SettingsLoading(),
        SettingsLoaded(categories: [...tCategories, 'Exercise']),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.addCategory('Exercise');
      verify(() => mockSaveCategoriesUseCase([...tCategories, 'Exercise'])).called(1);
    });

    test('removeCategory - should remove category and save', () async {
      // Mock initial load
      when(() => mockGetCategoriesUseCase(any()))
          .thenAnswer((_) async => Right(tCategories));
      when(() => mockSaveCategoriesUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      await cubit.loadCategories();

      final expected = [
        SettingsLoading(),
        const SettingsLoaded(categories: ['Work']),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.removeCategory('Study');
      verify(() => mockSaveCategoriesUseCase(['Work'])).called(1);
    });
  });
}
