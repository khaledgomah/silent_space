import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  String _language = 'ar';
void changeLanguage(Language language){
  if(language == Language.english){
    _language = 'en';
  }else{
    _language = 'ar';
  }
  emit(LanguageChange());
}
String get language => _language;
  LanguageCubit() : super(LanguageInitial());
}



enum Language{ english, arabic }