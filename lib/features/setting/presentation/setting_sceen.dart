import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:silent_space/core/helper/extentions.dart';
import 'package:silent_space/core/utils/on_generate_route.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/setting/data/models/setting_item_model.dart';
import 'package:silent_space/features/setting/presentation/widgets/change_language_modal_sheet.dart';
import 'package:silent_space/features/setting/presentation/widgets/setting_item_widget.dart';
import 'package:silent_space/generated/l10n.dart';

class SettingSceen extends StatelessWidget {
  const SettingSceen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingItemModel> settingItems = [
      SettingItemModel(
        onTap: () {
          context.pushNamed(RoutesName.categories);
        },
        title: S.of(context).categories,
        icon: const Icon(Icons.category),
      ),
      SettingItemModel(
          title: S.of(context).notifications,
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
        title: S.of(context).language,
        icon: const Icon(Icons.language),
      ),
      SettingItemModel(
        onTap: () {
          context.pushNamed(RoutesName.howToUse);
        },
        title: S.of(context).howToUse,
        icon: const Icon(Icons.help),
      ),
      SettingItemModel(
        onTap: () {
          context.pushNamed(RoutesName.aboutApp);
        },
        title: S.of(context).about,
        icon: const Icon(Icons.info),
      ),
      SettingItemModel(
        title: S.of(context).feedback,
        onTap: () {
          context.pushNamed(RoutesName.feedbackScreen);
        },
        icon: const Icon(Icons.feedback),
      ),
      SettingItemModel(
          title: S.of(context).RateUs,
          icon: const Icon(Icons.star),
          onTap: () {}),
      SettingItemModel(
          title: S.of(context).share,
          icon: const Icon(Icons.share),
          onTap: () {
            Share.share('check out my website https://example.com');
          }),
    ];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
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
      ),
    );
  }
}
