import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/core/cubits/language_cubit/language_cubit.dart';
import 'package:silent_space/core/helper/extensions.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/app_strings.dart';

class ChangeLanguageModalSheet extends StatelessWidget {
  const ChangeLanguageModalSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(
            minHeight: context.height() * 0.3,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  leading: const SizedBox(),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  title: Text(AppStrings.selectLanguage.tr()),
                  actions: [
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(AppStrings.english.tr()),
                  trailing: context.locale.languageCode == 'en'
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.setLocale(const Locale('en'));
                    context.read<LanguageCubit>().changeLanguage('en');
                    context.pop();
                  },
                ),
                ListTile(
                  title: Text(AppStrings.arabic.tr()),
                  trailing: context.locale.languageCode == 'ar'
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    context.setLocale(const Locale('ar'));
                    context.read<LanguageCubit>().changeLanguage('ar');
                    context.pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
