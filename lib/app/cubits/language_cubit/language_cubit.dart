import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silent_space/core/utils/service_locator.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  String _language = 'en';
 late SharedPreferencesWithCache prefsWithCache=getIt<SharedPreferencesWithCache>();
  Future<void> changeLanguage(Language language) async {
   
    if (language == Language.english) {
      _language = 'en';
    } else {
      _language = 'ar';
    }
    prefsWithCache.setString('language', _language);
    emit(LanguageChange());
  }

  String language(SharedPreferencesWithCache prefsWithCache) {
    return prefsWithCache.getString('language').toString();
  }

  LanguageCubit() : super(LanguageInitial());
}

enum Language { english, arabic }
