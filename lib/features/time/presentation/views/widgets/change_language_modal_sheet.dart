import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/app/cubits/language_cubit/language_cubit.dart';
import 'package:silent_space/core/helper/extentions.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/generated/l10n.dart';

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
                  title: Text(S.of(context).selectLanguage),
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
                  title: Text(S.of(context).english),
                  onTap: () {
                    BlocProvider.of<LanguageCubit>(context)
                        .changeLanguage(Language.english);
                    context.pop();
                  },
                ),
                ListTile(
                  title: Text(S.of(context).arabic),
                  onTap: () {
                    BlocProvider.of<LanguageCubit>(context)
                        .changeLanguage(Language.arabic);
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
