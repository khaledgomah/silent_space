import 'package:flutter/material.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';

class ShowDataContainer extends StatelessWidget {
  const ShowDataContainer({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (context.screenWidth() / 2) - 24,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.withOpacity(0.2)),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyleManager.bodyText1,
          ),
          Text(
            value.toString(),
            style: TextStyleManager.bodyText1,
          ),
        ],
      ),
    );
  }
}
