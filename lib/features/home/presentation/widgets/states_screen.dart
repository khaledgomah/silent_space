import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/home/presentation/widgets/focus_chart.dart';
import 'package:silent_space/features/home/presentation/widgets/show_details.dart';
import 'package:silent_space/generated/l10n.dart';

class StatesScreen extends StatelessWidget {
  const StatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 32,
          ),
          Text(
            S.of(context).today,
            style: TextStyleManager.headline2,
          ),
          const SizedBox(height: 8),
          const ShowDetails(),
          const SizedBox(height: 48),
          Text(
            S.of(context).summary,
            style: TextStyleManager.headline2,
          ),
          const SizedBox(height: 8),
          const ShowDetails(),
          const SizedBox(height: 48),
          Text(
            S.of(context).focusTime,
            style: TextStyleManager.headline2,
          ),
          const SizedBox(height: 8),
          const FocusChart(),
        ],
      ),
    );
  }
}