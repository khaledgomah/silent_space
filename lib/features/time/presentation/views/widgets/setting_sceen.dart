import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silent_space/app/cubits/language_cubit/language_cubit.dart';
import 'package:silent_space/core/helper/extentions.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/time/data/models/setting_item_model.dart';
import 'package:silent_space/features/time/presentation/views/widgets/change_language_modal_sheet.dart';
import 'package:silent_space/features/time/presentation/views/widgets/setting_item_widget.dart';
import 'package:silent_space/generated/l10n.dart';

class SettingSceen extends StatelessWidget {
  const SettingSceen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingItemModel> settingItems = [
      SettingItemModel(
          title: S.of(context).categories,
          icon: const Icon(Icons.category),
          onTap: () {}),
      SettingItemModel(
          title: S.of(context).notifications,
          icon: const Icon(Icons.notifications),
          onTap: () {}),
      SettingItemModel(
          title: S.of(context).language,
          icon: const Icon(Icons.language),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const ChangeLanguageModalSheet();
                });
          }),
      SettingItemModel(
          title: S.of(context).howToUse,
          icon: const Icon(Icons.help),
          onTap: () {}),
      SettingItemModel(
          title: S.of(context).about,
          icon: const Icon(Icons.info),
          onTap: () {}),
      SettingItemModel(
          title: S.of(context).feedback,
          icon: const Icon(Icons.feedback),
          onTap: () {}),
      SettingItemModel(
          title: S.of(context).RateUs,
          icon: const Icon(Icons.star),
          onTap: () {}),
      SettingItemModel(
          title: S.of(context).share,
          icon: const Icon(Icons.share),
          onTap: () {}),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 18, right: 18),
          child: Text(
            S.of(context).generalSettings,
            style: TextStyleManager.headline2,
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: settingItems.length,
          itemBuilder: (context, index) =>
              SettingItemWidget(item: settingItems[index]),
        ),
      ],
    );
  }
}
