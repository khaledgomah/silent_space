import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:silent_space/core/cubits/language_cubit/language_cubit.dart';
import 'package:silent_space/core/theme/app_theme.dart';
import 'package:silent_space/core/theme/theme_cubit.dart';
import 'package:silent_space/core/utils/globals.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/features/time/presentation/manager/timer_cubit/timer_cubit.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/core/utils/service_locator.dart';
import 'package:silent_space/features/session/presentation/cubit/session_cubit.dart';

class SilentSpace extends StatelessWidget {
  const SilentSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => TimerCubit()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<SessionCubit>()),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, langState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                initialRoute: RoutesName.splash,
                onGenerateRoute: onGenerateRoute,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode:
                    themeState.isDark ? ThemeMode.dark : ThemeMode.light,
              );
            },
          );
        },
      ),
    );
  }
}
