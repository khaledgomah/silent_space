import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/cubits/language_cubit/language_cubit.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late LanguageCubit cubit;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    cubit = LanguageCubit(prefs: mockSharedPreferences);
  });

  group('LanguageCubit', () {
    test('initial state should be LanguageInitial', () {
      expect(cubit.state, isA<LanguageInitial>());
    });

    test('changeLanguage - should save to SharedPreferences and emit LanguageChange', () async {
      when(() => mockSharedPreferences.setString('language', 'ar')).thenAnswer((_) async => true);

      final expected = [
        isA<LanguageChange>(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.changeLanguage('ar');

      verify(() => mockSharedPreferences.setString('language', 'ar')).called(1);
    });
  });
}
