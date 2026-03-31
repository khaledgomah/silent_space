import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/utils/service_locator.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isDark: true)) {
    _loadTheme();
  }

  final SharedPreferences _prefs = getIt<SharedPreferences>();

  void _loadTheme() {
    final isDark = _prefs.getBool('isDarkTheme') ?? true;
    emit(ThemeState(isDark: isDark));
  }

  void toggleTheme() {
    final newIsDark = !state.isDark;
    _prefs.setBool('isDarkTheme', newIsDark);
    emit(ThemeState(isDark: newIsDark));
  }
}
