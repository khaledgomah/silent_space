import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/utils/service_locator.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());
  final SharedPreferences _prefs = getIt<SharedPreferences>();

  Future<void> changeLanguage(String languageCode) async {
    await _prefs.setString('language', languageCode);
    emit(LanguageChange());
  }
}
