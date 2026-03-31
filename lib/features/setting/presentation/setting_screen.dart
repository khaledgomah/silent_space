import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:silent_space/core/helper/extensions.dart';
import 'package:silent_space/core/theme/theme_cubit.dart';
import 'package:silent_space/core/utils/app_strings.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:silent_space/features/setting/data/models/setting_item_model.dart';
import 'package:silent_space/features/setting/presentation/widgets/change_language_modal_sheet.dart';
import 'package:silent_space/features/setting/presentation/widgets/setting_item_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingItemModel> settingItems = [
      SettingItemModel(
        title: context.watch<ThemeCubit>().state.isDark
            ? AppStrings.lightMode.tr()
            : AppStrings.darkMode.tr(),
        icon: Icon(context.watch<ThemeCubit>().state.isDark ? Icons.light_mode : Icons.dark_mode),
        onTap: () {
          context.read<ThemeCubit>().toggleTheme();
        },
      ),
      SettingItemModel(
        onTap: () {
          context.pushNamed(RoutesName.categories);
        },
        title: AppStrings.categories.tr(),
        icon: const Icon(Icons.category),
      ),
      SettingItemModel(
          title: AppStrings.notifications.tr(),
          icon: const Icon(Icons.notifications),
          onTap: () {}),
      SettingItemModel(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return const ChangeLanguageModalSheet();
              });
        },
        title: AppStrings.language.tr(),
        icon: const Icon(Icons.language),
      ),
      SettingItemModel(
        onTap: () {
          context.pushNamed(RoutesName.howToUse);
        },
        title: AppStrings.howToUse.tr(),
        icon: const Icon(Icons.help),
      ),
      SettingItemModel(
        onTap: () {
          context.pushNamed(RoutesName.aboutApp);
        },
        title: AppStrings.about.tr(),
        icon: const Icon(Icons.info),
      ),
      SettingItemModel(
        title: AppStrings.feedback.tr(),
        onTap: () {
          context.pushNamed(RoutesName.feedbackScreen);
        },
        icon: const Icon(Icons.feedback),
      ),
      SettingItemModel(title: AppStrings.rateUs.tr(), icon: const Icon(Icons.star), onTap: () {}),
      SettingItemModel(
          title: AppStrings.share.tr(),
          icon: const Icon(Icons.share),
          onTap: () {
            Share.share('check out my website https://example.com');
          }),
      SettingItemModel(
        title: AppStrings.logout.tr(),
        icon: const Icon(Icons.logout, color: Colors.red),
        onTap: () {
          context.read<AuthCubit>().signOut();
          Navigator.pushReplacementNamed(context, RoutesName.login);
        },
      ),
    ];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 18, right: 18),
            child: Text(
              AppStrings.generalSettings.tr(),
              style: TextStyleManager.headline2,
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: settingItems.length,
            itemBuilder: (context, index) => SettingItemWidget(item: settingItems[index]),
          ),
        ],
      ),
    );
  }
}
