import 'package:flutter/material.dart';
import 'package:silent_space/core/helper/extentions.dart';
import 'package:silent_space/core/helper/helper_functions.dart';
import 'package:silent_space/core/utils/text_style_manager.dart';
import 'package:silent_space/generated/l10n.dart';

class TimerSettingModalSheet extends StatefulWidget {
  const TimerSettingModalSheet({super.key});

  @override
  State<TimerSettingModalSheet> createState() => _TimerSettingModalSheetState();
}

class _TimerSettingModalSheetState extends State<TimerSettingModalSheet> {
  double _focusSliderValue = 0;
  double _breakSliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: context.height() * 0.4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {},
                  icon: const Text(''),
                ),
                Text(
                  S.of(context).timerSettings,
                  style: TextStyleManager.bodyText1,
                ),
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                S.of(context).focusDuration,
                style: TextStyleManager.bodyText2,
              ),
            ),
            Slider(
              value: _focusSliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _focusSliderValue.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _focusSliderValue = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                S.of(context).breakDuration,
                style: TextStyleManager.bodyText2,
              ),
            ),
            Slider(
              value: _breakSliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _breakSliderValue.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _breakSliderValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
