import 'package:flutter/material.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/features/time/presentation/views/widgets/focus_chart.dart';
import 'package:silent_space/features/time/presentation/views/widgets/show_details.dart';

class StatesScreen extends StatelessWidget {
  const StatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          SizedBox(
            height: 32,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sammary',
              style: TextStyleManager.headline2,
            ),
          ),
          SizedBox(height: 8),
          ShowDetails(),
          SizedBox(height: 48),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Today',
              style: TextStyleManager.headline2,
            ),
          ),
          SizedBox(height: 8),
          ShowDetails(),
          SizedBox(height: 48),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Focus Time',
              style: TextStyleManager.headline2,
            ),
          ),
          SizedBox(height: 8),
          FocusChart(),
        ],
      ),
    );
  }
}
