import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/time/data/models/setting_item_model.dart';
import 'package:silent_space/features/time/presentation/views/home_view.dart';
import 'package:silent_space/features/time/presentation/views/widgets/setting_item_widget.dart';

class SettingSceen extends StatelessWidget {
  SettingSceen({super.key});
  final List<SettingItemModel> settingItems = [
    SettingItemModel(title: 'Dark Mode', icon: const Icon(Icons.dark_mode)),
    SettingItemModel(
        title: 'Notifications', icon: const Icon(Icons.notifications)),
    SettingItemModel(title: 'About', icon: const Icon(Icons.info)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 50, left: 18),
          child: Text(
            'General',
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
