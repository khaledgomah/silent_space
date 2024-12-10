import 'package:flutter/material.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';

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
        ],
      ),
    );
  }
}

class ShowDetails extends StatelessWidget {
  const ShowDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ShowDataContainer(title: 'Focas Time (min)', value: 10),
        SizedBox(width: 16),
        ShowDataContainer(title: 'Focus count', value: 1),
      ],
    );
  }
}

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
