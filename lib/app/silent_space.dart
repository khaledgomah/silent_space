import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:silent_space/app/cubits/language_cubit/language_cubit.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/generated/l10n.dart';

class SilentSpace extends StatelessWidget {
  const SilentSpace({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
  
        builder: (context, state) {
          return MaterialApp(
            locale: Locale(BlocProvider.of<LanguageCubit>(context).language(getIt<SharedPreferencesWithCache>())),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            initialRoute: RoutesName.splash,
            onGenerateRoute: onGenerateRoute,
            theme: ThemeData(brightness: Brightness.dark),
          );
        },
      ),
    );
  }
}
