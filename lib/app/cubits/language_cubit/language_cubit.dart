import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  String language = 'ar';
  LanguageCubit() : super(LanguageInitial());
}
