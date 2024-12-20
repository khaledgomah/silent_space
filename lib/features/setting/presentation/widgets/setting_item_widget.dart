import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/constans.dart';
import 'package:silent_space/features/setting/data/models/setting_item_model.dart';

class SettingItemWidget extends StatelessWidget {
  const SettingItemWidget({super.key, required this.item});

  final SettingItemModel item;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Constants.secondaryColor),
        padding:
            WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8)),
        shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
      ),
      onPressed: item.onTap,
      child: ListTile(
        leading: item.icon,
        title: Text(item.title),
      ),
    );
  }
}
