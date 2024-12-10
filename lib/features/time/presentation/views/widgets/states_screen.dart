import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/time/presentation/views/widgets/focus_chart.dart';
import 'package:silent_space/features/time/presentation/views/widgets/show_details.dart';

class StatesScreen extends StatelessWidget {
  const StatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double opacityValue = 0.2;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 32,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sammary',
              style: TextStyleManager.headline2,
            ),
          ),
          const SizedBox(height: 8),
          const ShowDetails(),
          const SizedBox(height: 48),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Today',
              style: TextStyleManager.headline2,
            ),
          ),
          const SizedBox(height: 8),
          const ShowDetails(),
          const SizedBox(height: 48),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Focus Time',
              style: TextStyleManager.headline2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(opacityValue),
              ),
              height: context.screenHeight() * 0.3,
              child: const FocusChart()),
        ],
      ),
    );
  }
}
