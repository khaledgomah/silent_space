import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/theme/theme_cubit.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ThemeCubit cubit;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
  });

  group('ThemeCubit', () {
    test('initial state should be dark theme (true) if SharedPreferences returns null', () {
      when(() => mockSharedPreferences.getBool('isDarkTheme')).thenReturn(null);

      cubit = ThemeCubit(prefs: mockSharedPreferences);

      expect(cubit.state.isDark, isTrue);
    });

    test('initial state should reflect SharedPreferences saved value', () {
      when(() => mockSharedPreferences.getBool('isDarkTheme')).thenReturn(false);

      cubit = ThemeCubit(prefs: mockSharedPreferences);

      expect(cubit.state.isDark, isFalse);
    });

    test('toggleTheme - should toggle theme and save to SharedPreferences', () {
      when(() => mockSharedPreferences.getBool('isDarkTheme')).thenReturn(true);
      when(() => mockSharedPreferences.setBool('isDarkTheme', false)).thenAnswer((_) async => true);

      cubit = ThemeCubit(prefs: mockSharedPreferences);

      cubit.toggleTheme();

      expect(cubit.state.isDark, isFalse);
      verify(() => mockSharedPreferences.setBool('isDarkTheme', false)).called(1);
    });
  });
}
